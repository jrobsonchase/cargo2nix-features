# This file was @generated by cargo2nix 0.10.0.
# It is not intended to be manually edited.

args@{
  release ? true,
  rootFeatures ? [
    "foo/default"
    "bar/default"
  ],
  rustPackages,
  buildRustPackages,
  hostPlatform,
  hostPlatformCpu ? null,
  hostPlatformFeatures ? [],
  codegenOpts ? null,
  profileOpts ? null,
  mkRustCrate,
  rustLib,
  lib,
  workspaceSrc,
}:
let
  workspaceSrc = if args.workspaceSrc == null then ./. else args.workspaceSrc;
in let
  inherit (rustLib) fetchCratesIo fetchCrateLocal fetchCrateGit fetchCrateAlternativeRegistry expandFeatures decideProfile genDrvsByProfile;
  profilesByName = {
  };
  rootFeatures' = expandFeatures rootFeatures;
  overridableMkRustCrate = f:
    let
      drvs = genDrvsByProfile profilesByName ({ profile, profileName }: mkRustCrate ({ inherit release profile hostPlatformCpu hostPlatformFeatures profileOpts codegenOpts; } // (f profileName)));
    in { compileMode ? null, profileName ? decideProfile compileMode release }:
      let drv = drvs.${profileName}; in if compileMode == null then drv else drv.override { inherit compileMode; };
in
{
  cargo2nixVersion = "0.10.0";
  workspace = {
    foo = rustPackages.unknown.foo."0.1.0";
    bar = rustPackages.unknown.bar."0.1.0";
  };
  "unknown".bar."0.1.0" = overridableMkRustCrate (profileName: rec {
    name = "bar";
    version = "0.1.0";
    registry = "unknown";
    src = fetchCrateLocal (workspaceSrc + "/bar");
    features = builtins.concatLists [
      [ "default" ]
      [ "python" ]
    ];
  });
  
  "unknown".foo."0.1.0" = overridableMkRustCrate (profileName: rec {
    name = "foo";
    version = "0.1.0";
    registry = "unknown";
    src = fetchCrateLocal workspaceSrc;
    features = builtins.concatLists [
      [ "default" ]
      [ "python" ]
    ];
    dependencies = {
      bar = rustPackages."unknown".bar."0.1.0" { inherit profileName; };
    };
  });
  
}