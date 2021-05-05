# juce-oss-template

This project was created as a tool to both document and automate the process of creating a new CMake-based [JUCE](https://github.com/juce-framework/JUCE) project for the purpose of open-source plugin development. I created it because I found I was cargo-culting from previous projects to create new ones, and in that process I often forgot things, and decided a script would be better.

The implementation is opinionated and doesn't attempt to offer the user a lot of options, just to create a basic project skeleton with minimum effort as a starting point.

No need to clone this repo, the script works without any local state. You can therefore run it directly with a curl.

However, because you should ***never*** run random scripts from the internet without seeing what they do first I recommend you check the [create-new-plugin.sh](https://raw.githubusercontent.com/vitling/juce-oss-template/main/create-new-plugin.sh) source before running

```sh
bash <(curl -fksSL https://raw.githubusercontent.com/vitling/juce-oss-template/main/create-new-plugin.sh)
```

Requires `envsubst` from GNU gettext, `curl` and `git` to be available on the path

It'll then create a project that can be built as usual with cmake

```sh
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel
```

## What does it do?

* Ask user for a plugin name and a GitHub username.
* Use these to derive file names, class names, manufacturer and plugin codes based on some opinionated string manipulation
* Use env var substitution on the files in `templates/` to create `CMakeLists.txt`, `YourPlugin.cpp` and `.gitignore` files
* Download a fresh copy of the GPL3 and put it in `COPYING`
* Init a git repo, add JUCE as a submodule, create a commit with the above files in

## Contributing/Further Development

I have only tested this script on MacOS 10.15 and briefly on a headless Linux box. Issues and Pull Requests to broaden the support to more platforms are welcomed and encouraged, as well as bug fixes and changes to the templates to use JUCE more "correctly" and to move with changes in JUCE itself.

I limit the scope of my own interest to be a quick-and-dirty bootstrap rather than, for example, replicating all the functionality of the Projucer in the CMake world. However, feel free to take any ideas or code from this repo to build out your own if that's your interest.

## License

This script and accompanying templates are free software, licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html). 

