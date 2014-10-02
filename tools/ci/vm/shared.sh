if [ -e ~/.bashrc ]; then source ~/.bashrc; fi
if [ -e ~/.bash_profile ]; then source ~/.bash_profile; fi

# clone_gemset <ruby_version> <original_gemset> <new_gemset>
function clone_gemset() {
  rm -rf ~/.rvm/gems/ruby-$1@$3
  cp -R ~/.rvm/gems/ruby-$1@$2 ~/.rvm/gems/ruby-$1@$3
}

# use_gemset <ruby_version> <gemset>
function use_gemset() {
  rvm use $1@$2
}

# delete_gemset <ruby_version> <gemset>
function delete_gemset() {
  rvm --force gemset delete $1@$2
}

# resolve_dir <dir>
function resolve_dir() {
  cd $1 2> /dev/null || return $?
  pwd -P
}

RUBY_VERSION=1.9.3-p448
GEMSET_NAME=$(basename $(resolve_dir $(dirname $0)/../../../))
HOBO_GEMSET_NAME=hobo-0.0.13
