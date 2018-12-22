##### Quick Setup
Simply double-click the Wireshark package. For details about the installation read below.
##### The installer writes to the following locations
- /Applications/Wireshark.app. The main Wireshark application.
- /Library/LaunchDaemons/org.wireshark.ChmodBPF.plist. A launch daemon that adjusts permissions on the system's packet capture devices (/dev/bpf*) when the system starts up.
- /Library/Application Support/Wireshark/ChmodBPF A copy of the launch daemon property list, and the script that the launch daemon runs.
- /usr/local/bin. A wrapper script and symbolic links which will let you run Wireshark and its associated utilities from the command line. You can access them directly or by adding /usr/local/bin to your PATH if it's not already in your PATH.
- /etc/paths.d/Wireshark. The folder name in this file is automatically added to PATH
- /etc/manpaths.d/Wireshark. The folder name in this file is used by the man command.
##### How do I uninstall?
- 1.Remove /Applications/Wireshark.app
- 2.Remove /Library/Application Support/Wireshark
- 3.Remove the wrapper scripts from /usr/local/bin
- 4.Unload the org.wireshark.ChmodBPF.plist launchd job
- 5.Remove /Library/LaunchDaemons/org.wireshark.ChmodBPF.plist
- 6.Remove the access_bpf group.
- 7.Remove /etc/paths.d/Wireshark
- 8.Remove /etc/manpaths.d/Wireshark
