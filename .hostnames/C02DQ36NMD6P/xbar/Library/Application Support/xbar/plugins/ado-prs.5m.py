#!/usr/local/bin/python3

#  <xbar.title>Azure DevOps Pull Requests</xbar.title>
#  <xbar.version>0.0.1</xbar.version>
#  <xbar.author>William Artero</xbar.author>
#  <xbar.author.github>wwmoraes</xbar.author.github>
#  <xbar.desc>Lists and links Azure DevOps pull requests. Requires azure-devops, keyring and termcolor packages.</xbar.desc>
#  <xbar.dependencies>python3,azure-devops,keyring,termcolor</xbar.dependencies>
#  <xbar.abouturl>http://github.com/wwmoraes/dotfiles</xbar.abouturl>

#  <xbar.var>string(ORGANIZATION=""): Azure DevOps organization URL. (required)</xbar.var>
#  <xbar.var>string(PROJECTS=""): Comma-separated name or ID of projects. (required)</xbar.var>
#  <xbar.var>string(REPOSITORIES=""): Comma-separated repository names. (optional)</xbar.var>
#  <xbar.var>string(PREFIXES=""): Comma-separated repository name prefixes. (optional)</xbar.var>

import os
import sys

from datetime import datetime
from itertools import groupby
from typing import Callable, List
from urllib.parse import urljoin
from urllib3.exceptions import HTTPError

from azure.devops.credentials import BasicAuthentication
from azure.devops.connection import Connection
from azure.devops.exceptions import ClientException
from azure.devops.v6_0.git.git_client import GitClient
from azure.devops.v6_0.git.models import \
  GitPullRequest, \
  IdentityRef, \
  GitRepository
import keyring
from termcolor import colored

print("↓⤸")
print("---")

ORGANIZATION = os.environ.get("ORGANIZATION", os.environ.get("AZURE_DEVOPS_DEFAULTS_ORGANIZATION"))
PROJECTS = [v for v in os.environ.get("PROJECTS", os.environ.get("AZURE_DEVOPS_DEFAULTS_PROJECT", "")).split(",") if len(v) > 0]
REPOSITORIES = [v for v in os.environ.get("REPOSITORIES", "").split(",") if len(v) > 0]
PREFIXES = [v for v in os.environ.get("PREFIXES", "").split(",") if len(v) > 0]

if not len(PREFIXES) > 0:
  repositoryHasAnyPrefix: Callable[[str], bool] = lambda _: True
else:
  def check(name: str) -> bool:
    for prefix in PREFIXES:
      if name.startswith(prefix):
        return True
    return False
  repositoryHasAnyPrefix = check

try:
  assert ORGANIZATION != None and len(ORGANIZATION) > 0, "Please set the variable ORGANIZATION"
  ORGANIZATION = ORGANIZATION.rstrip("/")

  AZURE_DEVOPS_EXT_PAT = os.environ.get("AZURE_DEVOPS_EXT_PAT", keyring.get_password(f"azdevops-cli:{ORGANIZATION}", "Personal Access Token"))
  assert AZURE_DEVOPS_EXT_PAT != None and len(AZURE_DEVOPS_EXT_PAT) > 0, "Please login to Azure DevOps using the CLI"

  assert len(PROJECTS) > 0, "Please set the variable PROJECTS"

  credentials = BasicAuthentication(username="", password=AZURE_DEVOPS_EXT_PAT)
  connection = Connection(ORGANIZATION, credentials)

  git: GitClient = connection.clients.get_git_client()
  connection.authenticate()
except ClientException as err: # ado errors
  print(err)
  sys.exit(0)
except HTTPError as err: # urllib errors
  print(err)
  sys.exit(0)
except ConnectionError as err: # native errors
  print(err.strerror)
  sys.exit(0)
except Exception as err: # anything else
  raise
  # print(err)
  # sys.exit(1)

keyFn: Callable[[GitPullRequest], str] = lambda pr: str(pr.repository.name)
entries: List[str] = []
for project in PROJECTS:
  projectPRs: List[GitPullRequest] = sorted([
    pr for pr in git.get_pull_requests_by_project(project=project, search_criteria=None)
    if repositoryHasAnyPrefix(pr.repository.name)
  ], key=keyFn)

  if not len(projectPRs) > 0:
    continue

  for repo, PRs in groupby(projectPRs, key=keyFn):
    entries.append("---")
    entries.append(f"{project}/{repo} | href={ORGANIZATION}/{project}/_git/{repo}/pullrequests color=cadetblue size=11")
    for pr in PRs:
      creator: IdentityRef = pr.created_by
      repository: GitRepository = pr.repository
      prUrl = urljoin(ORGANIZATION, f"{project}/_git/{repository.name}/pullrequest/{pr.pull_request_id}")
      entries.append(f"{colored(pr.pull_request_id, 'yellow', attrs=['bold'])}\t{pr.title} {colored('[%s]' % creator.display_name, 'cyan', attrs=['bold'])} | href={prUrl} ansi=true")

lastUpdate = datetime.now().astimezone().strftime("%a %b %d %Y %H:%M:%S %Z")
print(f"Last update: {lastUpdate} | disabled=true | size=10")
[print(entry) for entry in entries]
print("---")
print("Refresh | refresh=true key=CmdOrCtrl+r")
