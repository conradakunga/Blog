---
layout: post
title: "FIX - Workload manifest microsoft.net.workload.emscripten.current: 10.0.100/10.0.100 from workload version 10.0.100.1 was not installed"
date: 2025-12-11 00:05:27 +0300
categories:
    - .NET
---

If you are using [.NET](https://dotnet.microsoft.com/en-us/) on [macOS](https://en.wikipedia.org/wiki/MacOS) and you have recently updated to .NET SDK `10.0.1` you might run into the following **error** if you attempt to build or run a .NET project:

```plaintext
Welcome to .NET 10.0!
---------------------
SDK Version: 10.0.101

Telemetry
---------
The .NET tools collect usage data in order to help us improve your experience. It is collected by Microsoft and shared with the community. You can opt-out of telemetry by setting the DOTNET_CLI_TELEMETRY_OPTOUT environment variable to '1' or 'true' using your favorite shell.

Read more about .NET CLI Tools telemetry: https://aka.ms/dotnet-cli-telemetry

----------------
Installed an ASP.NET Core HTTPS development certificate.
To trust the certificate, run 'dotnet dev-certs https --trust'
Learn about HTTPS: https://aka.ms/dotnet-https

----------------
Write your first app: https://aka.ms/dotnet-hello-world
Find out what's new: https://aka.ms/dotnet-whats-new
Explore documentation: https://aka.ms/dotnet-docs
Report issues and find source on GitHub: https://github.com/dotnet/core
Use 'dotnet --help' to see available commands or visit: https://aka.ms/dotnet-cli
--------------------------------------------------------------------------------------
An issue was encountered verifying workloads. For more information, run "dotnet workload update".
   failed with 1 error(s) (0.0s)
    /usr/local/share/dotnet/sdk/10.0.101/Sdks/Microsoft.NET.Sdk/targets/Microsoft.NET.Sdk.ImportWorkloads.props(14,38): error MSB4242: 
      SDK Resolver Failure: "The SDK resolver "Microsoft.DotNet.MSBuildWorkloadSdkResolver" failed while attempting to resolve the SDK "Microsoft.NET.SDK.WorkloadAutoImport
      PropsLocator". Exception: "System.IO.FileNotFoundException: Workload manifest microsoft.net.workload.emscripten.current: 10.0.100/10.0.100 from workload version 10.0.
      100.1 was not installed. Running "dotnet workload repair" may resolve this.
         at Microsoft.NET.Sdk.WorkloadManifestReader.SdkDirectoryWorkloadManifestProvider.GetManifests()
         at Microsoft.NET.Sdk.WorkloadManifestReader.WorkloadResolver.LoadManifestsFromProvider(IWorkloadManifestProvider manifestProvider)
         at Microsoft.NET.Sdk.WorkloadManifestReader.WorkloadResolver.InitializeManifests()
         at Microsoft.NET.Sdk.WorkloadManifestReader.WorkloadResolver.GetInstalledWorkloadPacksOfKind(WorkloadPackKind kind)+MoveNext()
         at Microsoft.NET.Sdk.WorkloadMSBuildSdkResolver.CachingWorkloadResolver.Resolve(String sdkReferenceName, IWorkloadManifestProvider manifestProvider, IWorkloadResol
      ver workloadResolver)
         at Microsoft.NET.Sdk.WorkloadMSBuildSdkResolver.CachingWorkloadResolver.Resolve(String sdkReferenceName, String dotnetRootPath, String sdkVersion, String userProfi
      leDir, String globalJsonPath)
         at Microsoft.NET.Sdk.WorkloadMSBuildSdkResolver.WorkloadSdkResolver.Resolve(SdkReference sdkReference, SdkResolverContext resolverContext, SdkResultFactory factory
      )
         at Microsoft.Build.BackEnd.SdkResolution.SdkResolverService.TryResolveSdkUsingSpecifiedResolvers(IReadOnlyList`1 resolvers, Int32 submissionId, SdkReference sdk, L
      oggingContext loggingContext, ElementLocation sdkReferenceLocation, String solutionPath, String projectPath, Boolean interactive, Boolean isRunningInVisualStudio, Sdk
      Result& sdkResult, IEnumerable`1& errors, IEnumerable`1& warnings)""

Build failed with 1 error(s) in 0.1s
```

You will likely get this problem if you:

1. Use [Homebrew](https://brew.sh/)
2. Use these casks on [isen-ng](https://github.com/isen-ng/homebrew-dotnet-sdk-versions)

The error tells you to run `dotnet workload repair`.

This **does not work**, at least as of the time of writing this.

Your options are as follows:

1. If you haven't updated already, stay on SDK 10.0.0
2. If you have, uninstall the 10.0.1 cask `brew uninstall --cask dotnet-sdk10` and then install the [official one](https://formulae.brew.sh/cask/dotnet-sdk) - `brew install --cask dotnet-sdk`
3. Wait for the [isn-ng](https://github.com/isen-ng/homebrew-dotnet-sdk-versions)) one to be fixed

Happy hacking!
