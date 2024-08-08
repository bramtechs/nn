{ pkgs ? import <nixpkgs> {} }:

with pkgs;

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "nn";
  version = "0.0.1";

  src = ./.;

  nativeBuildInputs = [ cmake ninja ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Non-nullable pointers for C++";
    homepage = "https://github.com/bramtechs/nn";
    license = licenses.asl20;
    maintainers = with maintainers; [ brambasiel ];
    platforms = platforms.all;
    changelog = "https://github.com/bramtechs/nn";
  };
})
