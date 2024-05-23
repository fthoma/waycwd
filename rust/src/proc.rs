use std::fs;

pub fn child_cwd_recursive(parent_pid: u32) -> String {
    let child_pid = proc_child_pid_recursive(parent_pid);
    let path = fs::read_link(format!("/proc/{}/cwd", child_pid)).unwrap();
    path.into_os_string().into_string().unwrap()
}

fn proc_child_pid_recursive(parent_pid: u32) -> u32 {
    let children = proc_children(parent_pid);
    let first_child = children.first();
    match first_child {
        Some(pid) => proc_child_pid_recursive(*pid),
        None => parent_pid,
    }
}

fn proc_children(parent_pid: u32) -> Vec<u32> {
    let children_path = format!("/proc/{0}/task/{0}/children", parent_pid);
    fs::read_to_string(children_path)
        .unwrap()
        .split(",")
        .filter_map(|s| s.trim().parse::<u32>().ok())
        .collect()
}
