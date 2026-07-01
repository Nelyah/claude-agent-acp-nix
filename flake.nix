{
  description = "Nix package for claude-agent-acp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      version = "0.54.1";

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      srcHash = "sha256-Ykwd1/RH9L/wSEJgc2HdhpDiIiE7wH19v/DQgpFKXFI=";
      npmDepsHash = "sha256-S3bpXFcOW6ZhM7KJ9hVrKIwT4eKg5oqmmloeCx6YnPw=";

      mkPackage = pkgs:
        pkgs.buildNpmPackage {
          pname = "claude-agent-acp";
          inherit version;

          src = pkgs.fetchFromGitHub {
            owner = "agentclientprotocol";
            repo = "claude-agent-acp";
            rev = "v${version}";
            hash = srcHash;
          };

          inherit npmDepsHash;

          meta = with pkgs.lib; {
            description = "Agent Client Protocol server for Claude Code";
            homepage = "https://github.com/agentclientprotocol/claude-agent-acp";
            license = licenses.asl20;
            platforms = supportedSystems;
            mainProgram = "claude-agent-acp";
          };
        };

    in {
      overlays.default = final: prev: {
        claude-agent-acp = mkPackage final;
      };

      packages = nixpkgs.lib.genAttrs supportedSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = mkPackage pkgs;
          claude-agent-acp = mkPackage pkgs;
        });
    };
}
