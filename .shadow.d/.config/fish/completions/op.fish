command -q op; or exit

function __op_seen_subcommand_of
  return (__fish_seen_subcommand_of $argv || __fish_seen_subcommand_of help $argv)
end

set -l categories "'Login' 'Bank Account' 'Membership' 'Server' 'Secure Note' 'Database' 'Outdoor License' 'Social Security Number' 'Credit Card' 'Driver License' 'Passport' 'Software License' 'Identity' 'Email Account' 'Reward Program' 'Wireless Router'"

# root flags
complete -fc op -n '__fish_no_arguments' -s v -l version -d "version for op"
# global flags
complete -xc op -n '__fish_not_contain_opt account' -l account -a "(jq -r '.accounts[].shorthand' ~/.config/op/config)" -d "use the account with this shorthand"
complete -fc op -n '__fish_not_contain_opt cache' -l cache -d "store and use cached information"
complete -xc op -n '__fish_not_contain_opt config' -l config -a "(__fish_complete_directories)" -d "use this configuration directory"
complete -xc op -n '__fish_not_contain_opt session' -l session -d "authenticate with this session token"
complete -fc op -n '__fish_not_contain_opt -s h help' -s h -l help -d "get help"
# root subcommands
complete -xc op -n __op_seen_subcommand_of -a add -d "Grant access to groups or vaults"
complete -xc op -n __op_seen_subcommand_of -a completion -d "Generate shell completion information"
complete -xc op -n __op_seen_subcommand_of -a confirm -d "Confirm a user"
complete -fc op -n __op_seen_subcommand_of -a create -d "Create an object"
complete -fc op -n __op_seen_subcommand_of -a delete -d "Remove an object"
complete -fc op -n __op_seen_subcommand_of -a edit -d "Edit an object"
complete -fc op -n __op_seen_subcommand_of -a encode -d "Encode the JSON needed to create an item"
complete -fc op -n __op_seen_subcommand_of -a forget -d "Remove a 1Password account from this device"
complete -fc op -n __op_seen_subcommand_of -a get -d "Get details about an object"
complete -fc op -n __fish_seen_subcommand_of -a help -d "Get help for a command"
complete -fc op -n __op_seen_subcommand_of -a list -d "List objects and events"
complete -fc op -n __op_seen_subcommand_of -a reactivate -d "Reactivate a suspended user"
complete -fc op -n __op_seen_subcommand_of -a remove -d "Revoke access to groups or vaults"
complete -fc op -n __op_seen_subcommand_of -a signin -d "Sign in to a 1Password account"
complete -fc op -n __op_seen_subcommand_of -a signout -d "Sign out of a 1Password account"
complete -xc op -n __op_seen_subcommand_of -a suspend -d "Suspend a user"
complete -fc op -n __op_seen_subcommand_of -a update -d "Check for and download updates"
# add subcommands
complete -fc op -n '__op_seen_subcommand_of add' -a group -d "Grant a group access to a vault"
complete -fc op -n '__op_seen_subcommand_of add' -a user -d "Grant a user access to a vault or group"
# add user flags
complete -xc op -n '__op_seen_subcommand_of add user && __fish_not_contain_opt role' -l role -a "(string split , member,manager)" -d "set the user's role in a group (member or manager) (default 'member')"
# completion subcommands
complete -fc op -n '__op_seen_subcommand_of completion' -a bash -d "Bourne again shell"
complete -fc op -n '__op_seen_subcommand_of completion' -a zsh -d "Z shell"
# confirm flags
complete -xc op -n '__op_seen_subcommand_of confirm' -l all -d "confirm all unconfirmed users"
# create subcommands
complete -rc op -n '__op_seen_subcommand_of create' -a document -d "Create a document"
complete -xc op -n '__op_seen_subcommand_of create' -a group -d "Create a group"
complete -xc op -n '__op_seen_subcommand_of create' -a item -d "Create an item"
complete -xc op -n '__op_seen_subcommand_of create' -a user -d "Create a user"
complete -xc op -n '__op_seen_subcommand_of create' -a vault -d "Create a vault"
# create document flags
complete -xc op -n '__op_seen_subcommand_of -p create document && __fish_not_contain_opt filename' -l filename -d "set the file's name"
complete -xc op -n '__op_seen_subcommand_of -p create document && __fish_not_contain_opt tags' -l tags -d "add one or more tags (comma-separated) to the item"
complete -xc op -n '__op_seen_subcommand_of -p create document && __fish_not_contain_opt title' -l title -d "set the item's title"
complete -xc op -n '__op_seen_subcommand_of -p create document && __fish_not_contain_opt vault' -l vault -d "save the document in this vault"
# create group flags
complete -xc op -n '__op_seen_subcommand_of -p create group && __fish_not_contain_opt description' -l description -d "set the group's description"
# create item flags
complete -xc op -n '__op_seen_subcommand_of -p create item && __fish_not_contain_opt generate-password' -l generate-password -d "give the item a randomly generated password"
complete -xc op -n '__op_seen_subcommand_of -p create item && __fish_not_contain_opt tags' -l tags -d "add one or more tags (comma-separated) to the item"
complete -xc op -n '__op_seen_subcommand_of -p create item && __fish_not_contain_opt title' -l title -d "set the item's title"
complete -xc op -n '__op_seen_subcommand_of -p create item && __fish_not_contain_opt url' -l url -d "set the URL associated with the item"
complete -xc op -n '__op_seen_subcommand_of -p create item && __fish_not_contain_opt vault' -l vault -d "save the item in this vault"
# create user flags
complete -xc op -n '__op_seen_subcommand_of -p create user && __fish_not_contain_opt language' -l language -d "set the user's account language (default 'en')"
# create vault flags
complete -xc op -n '__op_seen_subcommand_of -p create vault && __fish_not_contain_opt allow-admins-to-manage' -l allow-admins-to-manage -a "true false" -d "set whether admins can manage vault access"
complete -xc op -n '__op_seen_subcommand_of -p create vault && __fish_not_contain_opt description' -l description -d "set the group's description"
# delete subcommands
complete -xc op -n '__op_seen_subcommand_of delete' -a document -d "Move a document to the Trash"
complete -xc op -n '__op_seen_subcommand_of delete' -a group -d "Remove a group"
complete -xc op -n '__op_seen_subcommand_of delete' -a item -d "Move an item to the Trash"
complete -xc op -n '__op_seen_subcommand_of delete' -a trash -d "Empty a vault's Trash"
complete -xc op -n '__op_seen_subcommand_of delete' -a user -d "Completely remove a user"
complete -xc op -n '__op_seen_subcommand_of delete' -a vault -d "Remove a vault"
# delete document flags
complete -xc op -n '__op_seen_subcommand_of -p delete document && __fish_not_contain_opt vault' -l vault -d "look for the document in this vault"
# delete item flags
complete -xc op -n '__op_seen_subcommand_of -p delete item && __fish_not_contain_opt vault' -l vault -d "look for the item in this vault"
# edit subcommands
complete -fc op -n '__op_seen_subcommand_of edit' -a document -d "Edit a document"
complete -fc op -n '__op_seen_subcommand_of edit' -a group -d "Edit a group's name or description"
complete -fc op -n '__op_seen_subcommand_of edit' -a item -d "Edit an item's details"
complete -fc op -n '__op_seen_subcommand_of edit' -a user -d "Edit a user's name or Travel Mode status"
complete -fc op -n '__op_seen_subcommand_of edit' -a vault -d "Edit a vault's name"
# edit document flags
complete -xc op -n '__op_seen_subcommand_of -p edit document && __fish_not_contain_opt filename' -l filename -d "set the file's name"
complete -xc op -n '__op_seen_subcommand_of -p edit document && __fish_not_contain_opt tags' -l tags -d "add one or more tags (comma-separated) to the item"
complete -xc op -n '__op_seen_subcommand_of -p edit document && __fish_not_contain_opt title' -l title -d "set the item's title"
complete -xc op -n '__op_seen_subcommand_of -p edit document && __fish_not_contain_opt vault' -l vault -d "look up document in this vault"
# edit group flags
complete -xc op -n '__op_seen_subcommand_of -p edit group && __fish_not_contain_opt description' -l description -d "change the group's description"
complete -xc op -n '__op_seen_subcommand_of -p edit group && __fish_not_contain_opt name' -l name -d "change the group's name"
# edit item flags
complete -xc op -n '__op_seen_subcommand_of -p edit item && __fish_not_contain_opt generate-password' -l generate-password -d "give the item a randomly generated password"
complete -xc op -n '__op_seen_subcommand_of -p edit item && __fish_not_contain_opt vault' -l vault -d "look up for the item in this vault"
# edit user flags
complete -xc op -n '__op_seen_subcommand_of -p edit user && __fish_not_contain_opt name' -l name -d "set the user's name"
complete -xc op -n '__op_seen_subcommand_of -p edit user && __fish_not_contain_opt travelmode' -l travelmode -a "on off" -d "turn Travel Mode on or off for the user (default off)"
# edit vault flags
complete -xc op -n '__op_seen_subcommand_of -p edit vault && __fish_not_contain_opt name' -l name -d "change the vault's name"
# get subcommands
complete -fc op -n '__op_seen_subcommand_of get' -a account -d "Get details about your account"
complete -fc op -n '__op_seen_subcommand_of get' -a document -d "Download a document"
complete -fc op -n '__op_seen_subcommand_of get' -a group -d "Get details about a group"
complete -fc op -n '__op_seen_subcommand_of get' -a item -d "Get item details"
complete -fc op -n '__op_seen_subcommand_of get' -a template -d "Get an item template"
complete -fc op -n '__op_seen_subcommand_of get' -a totp -d "Get the one-time password for an item"
complete -fc op -n '__op_seen_subcommand_of get' -a user -d "Get details about a user"
complete -fc op -n '__op_seen_subcommand_of get' -a vault -d "Get details about a vault"
# get document flags
complete -fc op -n '__op_seen_subcommand_of -p get document && __fish_not_contain_opt include-trash' -l include-trash -d "include items from the Trash"
complete -rc op -n '__op_seen_subcommand_of -p get document && __fish_not_contain_opt output' -l output -d "save the document to the file path instead of stdout"
complete -xc op -n '__op_seen_subcommand_of -p get document && __fish_not_contain_opt vault' -l vault -d "look up for the document in this vault"
# get item flags
complete -xc op -n '__op_seen_subcommand_of -p get item && __fish_not_contain_opt fields' -l fields -d "only return data from these fields"
complete -xc op -n '__op_seen_subcommand_of -p get item && __fish_not_contain_opt format' -l format -a "CSV JSON" -d "return data in this format (CSV or JSON) (use with --fields)"
complete -fc op -n '__op_seen_subcommand_of -p get item && __fish_not_contain_opt include-trash' -l include-trash -d "include items in the Trash"
complete -fc op -n '__op_seen_subcommand_of -p get item && __fish_not_contain_opt share-link' -l share-link -d "get a shareable link for the item"
complete -xc op -n '__op_seen_subcommand_of -p get item && __fish_not_contain_opt vault' -l vault -d "look up for the item in this vault"
# get template options
complete -xc op -n '__op_seen_subcommand_of get template' -a $categories
# get totp flags
complete -xc op -n '__op_seen_subcommand_of -p get totp && __fish_not_contain_opt vault' -l vault -d "look up for the item in this vault"
# get user flags
complete -fc op -n '__op_seen_subcommand_of -p get user && __fish_not_contain_opt fingerprint' -l fingerprint -d "get the user's public key fingerprint"
complete -fc op -n '__op_seen_subcommand_of -p get user && __fish_not_contain_opt publickey' -l publickey -d "get the user's public key"
# list subcommands
complete -fc op -n '__op_seen_subcommand_of list' -a documents -d "Get a list of documents"
complete -fc op -n '__op_seen_subcommand_of list' -a events -d "Get a list of events from the Activity Log"
complete -fc op -n '__op_seen_subcommand_of list' -a groups -d "Get a list of groups"
complete -fc op -n '__op_seen_subcommand_of list' -a items -d "Get a list of items"
complete -fc op -n '__op_seen_subcommand_of list' -a templates -d "Get a list of templates"
complete -fc op -n '__op_seen_subcommand_of list' -a users -d "Get the list of users"
complete -fc op -n '__op_seen_subcommand_of list' -a vaults -d "Get a list of vaults"
# list documents flags
complete -fc op -n '__op_seen_subcommand_of -p list documents && __fish_not_contain_opt include-trash' -l include-trash -d "include documents in the Trash"
complete -xc op -n '__op_seen_subcommand_of -p list documents && __fish_not_contain_opt vault' -l vault -d "only list documents in this vault"
# list events flags
complete -xc op -n '__op_seen_subcommand_of -p list events && __fish_not_contain_opt eventid' -l eventid -d "start listing from event with ID eid"
complete -fc op -n '__op_seen_subcommand_of -p list events && __fish_not_contain_opt older' -l older -d "list events from before the specified event"
# list groups flags
complete -xc op -n '__op_seen_subcommand_of -p list groups && __fish_not_contain_opt user' -l user -d "list groups that a user belongs to"
complete -xc op -n '__op_seen_subcommand_of -p list groups && __fish_not_contain_opt vault' -l vault -d "list groups that have direct access to a vault"
# list items flags
complete -xc op -n '__op_seen_subcommand_of -p list items && __fish_not_contain_opt categories' -l categories -a $categories -d "only list items in these categories (comma-separated)"
complete -fc op -n '__op_seen_subcommand_of -p list items && __fish_not_contain_opt include-trash' -l include-trash -d "include items in the Trash"
complete -xc op -n '__op_seen_subcommand_of -p list items && __fish_not_contain_opt tags' -l tags -d "only list items with these tags (comma-separated)"
complete -xc op -n '__op_seen_subcommand_of -p list items && __fish_not_contain_opt vault' -l vault -d "only list items in this vault"
# list users flags
complete -xc op -n '__op_seen_subcommand_of -p list users && __fish_not_contain_opt group' -l group -d "list users who belong to a group"
complete -xc op -n '__op_seen_subcommand_of -p list users && __fish_not_contain_opt vault' -l vault -d "list users who have direct access to vault"
# list vaults flags
complete -xc op -n '__op_seen_subcommand_of -p list vaults && __fish_not_contain_opt group' -l group -d "list vaults a group has access to"
complete -xc op -n '__op_seen_subcommand_of -p list vaults && __fish_not_contain_opt user' -l user -d "list vaults a user has access to"
# remove subcommands
complete -fc op -n '__op_seen_subcommand_of remove' -a group -d "Revoke a group's access to a vault"
complete -fc op -n '__op_seen_subcommand_of remove' -a user -d "Revoke a user's access to a vault or group"
# signin flags
complete -fc op -n '__op_seen_subcommand_of signin && __fish_not_contain_opt -s r raw' -s r -l raw -d "only return the session token"
complete -xc op -n '__op_seen_subcommand_of signin' -l shorthand -d "set the short account name"
# signout flags
complete -fc op -n '__op_seen_subcommand_of signout' -l forget -d "remove the details for a 1Password account from this device"
# update flags
complete -fc op -n '__op_seen_subcommand_of update' -l directory -a "(__fish_complete_directories)" -d "download the update to this path"
