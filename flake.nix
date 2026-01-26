{
	description = "My Homelab IaC dev environment.";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		flake-utils.url = "github:numtide/flake-utils";
	};

	outputs = {
		self,
		nixpkgs,
		flake-utils,
		...
	}:
	flake-utils.lib.eachDefaultSystem (system:
		let
			# pkgs = nixpkgs.legacyPackages.${system};
			pkgs = import nixpkgs {
				inherit system;
				pkgs = nixpkgs.legacyPackages.${system};
				config.allowUnfree = true;
			};
		in rec {
			devShell = pkgs.mkShell {
				packages = with pkgs; [
					terraform
					ansible
					sops
					age
                    nodejs_25
                    yarn
                    act
                    awscli2
                    python3
				];

                    # export AWS_PROFILE="initial-admin"
				shellHook = ''
					echo "Starting new shell";
					export ANSIBLE_CONFIG="ansible/ansible.cfg"
                    export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"
                    export AWS_SDK_LOAD_CONFIG="1"
                    export SOPS_AGE_KEY_FILE="$(realpath ./secrets)/age-private.key"
				'';
			};
		}
	);
}