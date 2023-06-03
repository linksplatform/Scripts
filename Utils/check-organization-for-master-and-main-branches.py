import requests
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Check master and main branches in a GitHub organization")
parser.add_argument("org_name", help="Name of the GitHub organization")
parser.add_argument("access_token", help="GitHub Personal Access Token")
args = parser.parse_args()

ORG_NAME = args.org_name
ACCESS_TOKEN = args.access_token

BASE_URL = f"https://api.github.com/orgs/{ORG_NAME}/repos"
headers = {"Authorization": f"token {ACCESS_TOKEN}"}
repositories = []

def get_repositories(page):
    response = requests.get(BASE_URL, headers=headers, params={"per_page": 100, "page": page})
    if response.status_code == 200:
        return response.json()
    else:
        print(f"An error occurred while fetching repositories: {response.status_code} - {response.text}")
        return []

def branch_exists(repo, branch):
    branch_url = repo["branches_url"].replace("{/branch}", f"/{branch}")
    branch_response = requests.get(branch_url, headers=headers, allow_redirects=False)
    
    if branch_response.status_code == 200:
        branch_info = branch_response.json()
        return branch_info["name"] == branch
    else:
        return False

page = 1
while True:
    repo_list = get_repositories(page)
    if repo_list:
        repositories.extend(repo_list)
        page += 1
    else:
        break

for repo in repositories:
    has_master_branch = branch_exists(repo, "master")
    has_main_branch = branch_exists(repo, "main")

    if has_master_branch and has_main_branch:
        print(f"●master ●main : {repo['name']}")
    elif has_master_branch:
        print(f"●master ○main : {repo['name']}")
    elif has_main_branch:
        print(f"○master ●main : {repo['name']}")
    else:
        print(f"○master ○main : {repo['name']}")