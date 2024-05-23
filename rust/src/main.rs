mod sway;
mod proc;

fn main() {
    let focused_pid = sway::pid_of_focused_window();
    let child_cwd = proc::child_cwd_recursive(focused_pid);
    println!("{}", child_cwd)
}
