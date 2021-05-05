#!/usr/bin/env bash
set -e

REMOTE_TEMPLATE_URL=https://raw.githubusercontent.com/vitling/juce-oss-template/main/templates/
GNU_GPL_SRC=https://www.gnu.org/licenses/gpl-3.0.txt

function create4Code() {
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})$(tr '[:upper:]' '[:lower:]' <<< ${1:1:3})"
}

function upperFirst() {
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}

function removeNonAlphanumeric() {
    echo $(tr -c -d [:alnum:] <<< "$*")
}

read -p "Plugin Name (eg. My Additive Synth): " PLUGIN_NAME
read -p "Github Username: " GH_USERNAME


PLUGIN_UPPER_UNDERSCORE_FORM=$(echo $PLUGIN_NAME | tr -d '\n' | tr [:lower:] [:upper:] | tr -c [:alnum:] '_')
PLUGIN_SPACELESS_FORM=$(upperFirst $(removeNonAlphanumeric $PLUGIN_NAME))
LOWER_SPACELESS_FORM=$(echo $PLUGIN_SPACELESS_FORM | tr [:upper:] [:lower:])
 
PLUGIN_CODE=$(create4Code "${PLUGIN_SPACELESS_FORM}")
MANU_CODE=$(create4Code "${GH_USERNAME}")
BUNDLE_ID=io.github.${GH_USERNAME}.${LOWER_SPACELESS_FORM}
CLASSNAME=${PLUGIN_SPACELESS_FORM}PluginProcessor

export TMPL_PROJECT_NAME_UNDERSCORED=${PLUGIN_UPPER_UNDERSCORE_FORM}_PLUGIN
export TMPL_PROJECT_NAME_TITLECASE=${PLUGIN_SPACELESS_FORM}Plugin
export TMPL_CLASSNAME=${CLASSNAME}
export TMPL_SHORT_NAME=${PLUGIN_SPACELESS_FORM}
export TMPL_CREATOR=${GH_USERNAME}
export TMPL_MANUFACTURER_CODE=${MANU_CODE}
export TMPL_PLUGIN_CODE=${PLUGIN_CODE}
export TMPL_DESCRIPTION="TODO Add a good description here"
export TMPL_BUNDLE_ID=${BUNDLE_ID}
export TMPL_PROJECT_VERSION=0.0.1

TEMPLATE_VARS='$TMPL_PROJECT_NAME_UNDERSCORED:$TMPL_PROJECT_NAME_TITLECASE:$TMPL_CLASSNAME:$TMPL_SHORT_NAME:$TMPL_CREATOR:$TMPL_MANUFACTURER_CODE:$TMPL_PLUGIN_CODE:$TMPL_DESCRIPTION:$TMPL_BUNDLE_ID:$TMPL_PROJECT_VERSION'

TARGET_DIR=${LOWER_SPACELESS_FORM}

echo "Creating target dir $TARGET_DIR"
mkdir $TARGET_DIR 

echo "Downloading and filling templates"
curl -fksSL "${REMOTE_TEMPLATE_URL}/CMakeLists.txt.template" | envsubst "$TEMPLATE_VARS" > ${TARGET_DIR}/CMakeLists.txt
curl -fksSL "${REMOTE_TEMPLATE_URL}/Plugin.cpp.template" | envsubst "$TEMPLATE_VARS" > ${TARGET_DIR}/${TMPL_PROJECT_NAME_TITLECASE}.cpp
curl -fksSL "${REMOTE_TEMPLATE_URL}/gitignore.template" > "${TARGET_DIR}/.gitignore"

echo "Downloading GPL license"
curl $GNU_GPL_SRC > "${TARGET_DIR}/COPYING"

(cd $TARGET_DIR
    echo "Creating new git repo"
    git init

    echo "Adding JUCE framework as submodule"
    git submodule add --depth 1 https://github.com/juce-framework/JUCE.git

    echo "Creating initial commit to repo"
    git add CMakeLists.txt ${TMPL_PROJECT_NAME_TITLECASE}.cpp .gitignore COPYING
    git commit -am "Initial commit"
)
