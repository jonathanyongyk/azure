#!/usr/bin/env bash
# =============================================
#  Add User to Entra Security Group
#  Usage: ./add_user_to_group.sh <USER_UPN> <GROUP_NAME>
#  Example: ./add_user_to_group.sh john@contoso.com "SG-Developers"
# =============================================

set -euo pipefail

# -- Validate Arguments --
if [ -z "${1:-}" ]; then
    echo "ERROR: Missing USER_UPN argument."
    echo "Usage: $(basename "$0") <USER_UPN> <GROUP_NAME>"
    echo "Example: $(basename "$0") john@contoso.com \"SG-Developers\""
    exit 1
fi

if [ -z "${2:-}" ]; then
    echo "ERROR: Missing GROUP_NAME argument."
    echo "Usage: $(basename "$0") <USER_UPN> <GROUP_NAME>"
    echo "Example: $(basename "$0") john@contoso.com \"SG-Developers\""
    exit 1
fi

# -- Set Arguments --
USER_UPN="$1"
GROUP_NAME="$2"

# -- Login to Azure --
# Assume you are already logged in via az cli
# az login

# -- Get User Object ID --
USER_OID=$(az ad user show --id "$USER_UPN" --query id --output tsv 2>/dev/null) || true
if [ -z "$USER_OID" ]; then
    echo "ERROR: Could not find user with UPN: $USER_UPN"
    exit 1
fi
echo "User Object ID: $USER_OID"

# -- Get Group Object ID --
GROUP_OID=$(az ad group show --group "$GROUP_NAME" --query id --output tsv 2>/dev/null) || true
if [ -z "$GROUP_OID" ]; then
    echo "ERROR: Could not find group with name: $GROUP_NAME"
    exit 1
fi
echo "Group Object ID: $GROUP_OID"

# -- Add User to Group --
az ad group member add --group "$GROUP_OID" --member-id "$USER_OID"
echo "User $USER_UPN has been added to group: $GROUP_NAME"


