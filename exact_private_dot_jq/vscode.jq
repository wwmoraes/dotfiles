# vim: ft=jq

# this returns as an array of files found and loaded;
# use $exclusions[0] to get the first (and only)
import "vscode_exclusions" as $exclusions;

def flatten_exclusions(values):
  [ (values.full | map("^\(.)$"))
  , (values.group | map("^\(.)\\."))
  , (values.prefix | map("^\(.)"))
  ] | flatten;

def code_settings_keys(exclusions):
  [
    keys[]
    | select(. | test(exclusions | join("|")) | not)
  ]
  ;

def code_settings:
  . as $root
  | .["workbench.settings.applyToAllProfiles"]
  |= ($root | code_settings_keys(flatten_exclusions($exclusions[0])))
  ;
