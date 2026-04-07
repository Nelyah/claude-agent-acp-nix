{
  description = "Nix package for claude-agent-acp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      version = "0.25.3";

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      sources = {
        x86_64-linux = {
          suffix = "linux-x64";
          ext = "tar.gz";
          hash = "sha256-/mMD2CFN12rLzWTKOvZwmPRha0ttkhCDxvYB8fGOqwQ=";
        };
        aarch64-linux = {
          suffix = "linux-arm64";
          ext = "tar.gz";
          hash = "sha256-S6LuLTilQ32iHOZ/D0LNtMOCiB9PrErsV6od+xbd+0I=";
        };
        x86_64-darwin = {
          suffix = "darwin-x64";
          ext = "zip";
          hash = "sha256-6Fi8b3qx+P7Og/2iGFTn/bS88AguWJ2RetNUXJDfqMA=";
        };
        aarch64-darwin = {
          suffix = "darwin-arm64";
          ext = "zip";
          hash = "sha256-/mMD2CFN12rLzWTKOvZwmPRha0ttkhCDxvYB8fGOqwQ=";
        };
      };

      mkPackage = pkgs:
        let
          src = sources.${pkgs.stdenv.hostPlatform.system};
          isLinux = pkgs.stdenv.isLinux;
          isDarwin = pkgs.stdenv.isDarwin;
        in
        pkgs.stdenv.mkDerivation {
          pname = "claude-agent-acp";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/agentclientprotocol/claude-agent-acp/releases/download/v${version}/claude-agent-acp-${src.suffix}.${src.ext}";
            hash = src.hash;
          };

          nativeBuildInputs = pkgs.lib.optionals isDarwin [ pkgs.unzip ]
            ++ pkgs.lib.optionals isLinux [ pkgs.autoPatchelfHook ];

          buildInputs = pkgs.lib.optionals isLinux [
            pkgs.stdenv.cc.cc.lib
          ];

          sourceRoot = ".";

          dontBuild = true;
          dontConfigure = true;
          dontStrip = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            cp claude-agent-acp $out/bin/
            chmod +x $out/bin/claude-agent-acp
            runHook postInstall
          '';

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
