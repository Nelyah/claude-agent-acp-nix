# claude-agent-acp-nix

Nix flake for [claude-agent-acp](https://github.com/agentclientprotocol/claude-agent-acp). Automatically checks for new upstream releases daily and opens a PR.

## Usage

```sh
nix run github:Nelyah/claude-agent-acp-nix
```

### As an overlay

```nix
{
  inputs.claude-agent-acp-nix.url = "github:YOUR_ORG/claude-agent-acp-nix";

  outputs = { nixpkgs, claude-agent-acp-nix, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [{
        nixpkgs.overlays = [ claude-agent-acp-nix.overlays.default ];
        environment.systemPackages = [ pkgs.claude-agent-acp ];
      }];
    };
  };
}
```

## Supported platforms

`x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`
