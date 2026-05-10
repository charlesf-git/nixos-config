{
  # Your Linux username - this is the user account that will be configured
  # Run `whoami` to see your current username
  username = "charles";

  # Your machine's hostname
  # Run `hostname` to see your current hostname, or set anything you like
  # and NixOS will rename the machine on the next rebuild
  hostname = "nixos";

  # The CPU architecture of your machine
  system = "x86_64-linux";

  # Your name as it will appear in git commits
  gitName = "charlesf-git";

  # Your email as it will appear in git commits
  gitEmail = "charlesf.git@gmail.com";

  # Your login shell - determines which shell gets configured with aliases.
  # Run `echo $SHELL` to check. Common values: "bash" or "zsh"
  shell = "bash";

  # Graphics hardware vendor — controls which drivers are loaded and Vulkan ICD used.
  # Valid values: "nvidia" (Turing/RTX+), "nvidia-old" (pre-Turing, closed kernel module), "amd", "intel"
  gpu = "nvidia-old";

  # The NixOS state version - set this to the NixOS version you initially installed
  # and never change it afterwards, even when upgrading NixOS
  # Run `nixos-version` to see your current version
  stateVersion = "25.11";
}