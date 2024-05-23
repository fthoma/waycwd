use std::os::unix::net::UnixStream;
use std::io::prelude::*;
use std::str;
use serde::{Deserialize, Serialize};

pub fn pid_of_focused_window() -> u32 {
    let mut swayipc = SwayIpcSocket::connect().unwrap();
    let tree = swayipc.get_tree().unwrap();
    let node = focused_node([tree].to_vec());
    match node {
        Some(node) => node.pid.unwrap_or(0),
        None => 0,
    }
}

struct SwayIpcSocket
{
    stream: UnixStream,
}

#[derive(Debug)]
enum SwayError {
    ConnectionError,
    CommunicationError,
}

#[derive(Serialize, Deserialize, Clone)]
struct SwayNode {
    name: Option<String>,
    focused: Option<bool>,
    pid: Option<u32>,
    nodes: Option<Vec<SwayNode>>,
}

impl SwayIpcSocket {
    fn connect() -> Result<SwayIpcSocket, SwayError> {
        let path = SwayIpcSocket::socket_path()?;
        let stream = UnixStream::connect(path)
            .map_err(|_| SwayError::ConnectionError)?;

        Ok(SwayIpcSocket {stream})
    }

    fn socket_path() -> Result<String, SwayError> {
        std::env::var("SWAYSOCK")
            .map_err(|_| SwayError::ConnectionError)
    }

    fn get_tree(&mut self) -> Result<SwayNode, SwayError> {
        self.write(4, "")?;
        let payload = self.read()?;
        let node: SwayNode = serde_json::from_str(&payload).unwrap();
            //.map_err(|_| SwayError::CommunicationError)?;

        Ok(node)
    }

    fn write(&mut self, payload_type: i32, payload: &str) -> Result<(), SwayError> {
        let message = SwayIpcSocket::encode(payload_type, payload);
        self.stream.write_all(message.as_slice())
            .map_err(|_| SwayError::CommunicationError)?;
        Ok(())
    }

    fn read(&mut self) -> Result<String, SwayError> {
        let mut header = [0; 14];
        self.stream.read_exact(&mut header)
            .map_err(|_| SwayError::CommunicationError)?;
        let payload_len = i32::from_ne_bytes((&header[6..10]).try_into().unwrap());
        let mut payload = vec![0u8; payload_len.try_into().unwrap()];
        self.stream.read_exact(&mut payload)
            .map_err(|_| SwayError::CommunicationError)?;
        Ok(String::from_utf8(payload)
            .map_err(|_| SwayError::ConnectionError)?)
    }

    fn encode(payload_type: i32, payload: &str) -> Vec<u8> {
        let mut vec = Vec::new();
        vec.extend_from_slice(b"i3-ipc");
        vec.extend_from_slice(&(payload.chars().count() as i32).to_ne_bytes());
        vec.extend_from_slice(&payload_type.to_ne_bytes());
        vec.extend_from_slice(payload.as_bytes());
        vec
    }
}

fn focused_node(nodes: Vec<SwayNode>) -> Option<SwayNode> {
    let mut child_nodes = Vec::new();
    for node in nodes {
        if node.focused.unwrap_or(false) {
            return Some(node)
        }
        if node.nodes.is_some() {
            child_nodes.extend(node.nodes.unwrap())
        }
    }

    focused_node(child_nodes)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_swaymsg_encode() {
        let message = SwayIpcSocket::encode(0, "exit");
        assert_eq!(
            message.as_slice(),
            [105, 51, 45, 105, 112, 99, 4, 0, 0, 0, 0, 0, 0, 0, 101, 120, 105, 116],
            "Unexpected encoding")

    }
}
