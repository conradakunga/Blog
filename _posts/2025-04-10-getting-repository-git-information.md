---
layout: post
title: Getting Repository Git Information
date: 2025-04-10 15:07:26 +0300
categories:
    - Git
    - Source Control
---

[Source code control](https://www.atlassian.com/git/tutorials/source-code-management) has had various eras - there was the [CVS](https://cvs.nongnu.org/) era, followed by the [SubVersion](https://subversion.apache.org/) era, followed by the distributed source control systems era - [Mercurial](https://www.mercurial-scm.org/) and [Git](https://git-scm.com/).

**Git** (currently) has won that battle, and is by far the **most used source control versioning system**.

In the course if your work, perhaps in the **build process**, or just as a FYI, you might want to know some information about the repository you are in.

For example, if I needed to know the current tag of the branch I am in ...

```bash
git describe --tags
```

This will return the following (assuming there was an actual tag)

```plaintext
1.1.46-10-g4c46273
```

Suppose, as well, we needed to get the current **branch**.

This requires a bit more work.

If you are using [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)):

```bash
echo $(git rev-parse --abbrev-ref HEAD)
```

This returns the following (depending on your repository):

```plaintext
master
```

If you are using [PowerShell](https://learn.microsoft.com/en-us/powershell/):

```powershell
$branch = git rev-parse --abbrev-ref HEAD
```

You can also use a variable to capture this.

In **Bash**:

```bash
branch=$(git rev-parse --abbrev-ref HEAD)
echo $branch
```

In **PowerShell**

```powershell
$branch = git rev-parse --abbrev-ref HEAD
Write-Host $branch
```

While workable, it can quickly become **cumbersome** stitching together various scripts to get for you your repository information, especially if you are using it in a context such as [continuous integration](https://www.redhat.com/en/topics/devops/what-is-ci-cd) or automated release management.

There is a command line utility that can help with this -- [Gitversion](https://gitversion.net/).

It is a [.NET tool](https://learn.microsoft.com/en-us/dotnet/core/tools/global-tools) and can be installed in [several ways](https://gitversion.net/docs/usage/cli/installation) depending on your operating system.

Once installed you can run it as follows:

```bash
dotnet gitversion
```

This will return the following (depending on your repository!):

```json
{
  "AssemblySemFileVer": "1.1.47.0",
  "AssemblySemVer": "1.1.47.0",
  "BranchName": "master",
  "BuildMetaData": null,
  "CommitDate": "2025-04-11",
  "CommitsSinceVersionSource": 11,
  "EscapedBranchName": "master",
  "FullBuildMetaData": "Branch.master.Sha.d8cb74eef5c84a5133bf14c19fedfc0f4d0a181f",
  "FullSemVer": "1.1.47-11",
  "InformationalVersion": "1.1.47-11+Branch.master.Sha.d8cb74eef5c84a5133bf14c19fedfc0f4d0a181f",
  "Major": 1,
  "MajorMinorPatch": "1.1.47",
  "Minor": 1,
  "Patch": 47,
  "PreReleaseLabel": "",
  "PreReleaseLabelWithDash": "",
  "PreReleaseNumber": 11,
  "PreReleaseTag": "11",
  "PreReleaseTagWithDash": "-11",
  "SemVer": "1.1.47-11",
  "Sha": "d8cb74eef5c84a5133bf14c19fedfc0f4d0a181f",
  "ShortSha": "d8cb74e",
  "UncommittedChanges": 0,
  "VersionSourceSha": "47a095e8d61509938a7b43ea8d3497b5b8a7d043",
  "WeightedPreReleaseNumber": 55011
}
```

Given it is in `Json`, we have lots of options how to pick the data.

On **Bash** or **PowerShell**, you can **pipe the output** to the [jq](https://jqlang.org/) tool and extract whichever property you are interested in:

```bash
dotnet gitversion | jq .BranchName
```

This, will print the following:

```c#
"master"
```

You can even extract multiple values

```bash
dotnet gitversion | jq -r '.BranchName, .UncommittedChanges, .WeightedPreReleaseNumber'
```

You will get back a list of values:

```plaintext
master
0
55011
```

If you are using **PowerShell**, you can do it like this:

```c#
// Convert the json to an object
$json = dotnet gitversion | ConvertFrom-json 
// Get the properties
Write-Host $json.BrancName
```

In the context of a build environment like GitHub or TeamCity, you can output the data in DotEnv format, using the switch `/output dotenv`

```bash
dotnet gitversion /output dotenv
```

The output will look like this:

```plaintext
GitVersion_AssemblySemFileVer='1.1.47.0'
GitVersion_AssemblySemVer='1.1.47.0'
GitVersion_BranchName='master'
GitVersion_BuildMetaData=''
GitVersion_CommitDate='2025-04-11'
GitVersion_CommitsSinceVersionSource='11'
GitVersion_EscapedBranchName='master'
GitVersion_FullBuildMetaData='Branch.master.Sha.d8cb74eef5c84a5133bf14c19fedfc0f4d0a181f'
GitVersion_FullSemVer='1.1.47-11'
GitVersion_InformationalVersion='1.1.47-11+Branch.master.Sha.d8cb74eef5c84a5133bf14c19fedfc0f4d0a181f'
GitVersion_Major='1'
GitVersion_MajorMinorPatch='1.1.47'
GitVersion_Minor='1'
GitVersion_Patch='47'
GitVersion_PreReleaseLabel=''
GitVersion_PreReleaseLabelWithDash=''
GitVersion_PreReleaseNumber='11'
GitVersion_PreReleaseTag='11'
GitVersion_PreReleaseTagWithDash='-11'
GitVersion_SemVer='1.1.47-11'
GitVersion_Sha='d8cb74eef5c84a5133bf14c19fedfc0f4d0a181f'
GitVersion_ShortSha='d8cb74e'
GitVersion_UncommittedChanges='0'
GitVersion_VersionSourceSha='47a095e8d61509938a7b43ea8d3497b5b8a7d043'
GitVersion_WeightedPreReleaseNumber='55011'
```

These can be used to set [environment variables](https://www.dreamhost.com/blog/environment-variables/), or output to a .[env](https://dotenvx.com/docs/env-file) file.

### TLDR

**`GitVersion` is a dotnet tool that makes it easy to extract git information for use in a build process.**

Happy hacking!
