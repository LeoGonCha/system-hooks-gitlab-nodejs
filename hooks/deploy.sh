#!/bin/sh

HOOK_DIR=/srv/repositories/DEINF.BELFORT/ProjetoParaTestes.git/custom_hooks
HOME=/srv/source

if [ -d $HOME ]; then
        cd $HOME
else
        echo "${$HOME} not found"
        exit 1
fi

dos2unix *.rb 2> /dev/null

if [ -e $HOME/custom_pre_receive.rb ]; then
    sudo mv custom_pre_receive.rb $HOOK_DIR/pre-receive
    sudo chown -R pcp:root $HOOK_DIR/*
    sudo chmod 755 $HOOK_DIR/pre-receive
fi

if [ -e $HOME/custom_update.rb ]; then
    sudo mv custom_update.rb $HOOK_DIR/update
    sudo chown -R pcp:root $HOOK_DIR/*
    sudo chmod 755 $HOOK_DIR/update
fi

if [ -e $HOME/gitlab_rest_client.rb ]; then
    sudo mv gitlab_rest_client.rb $HOOK_DIR
fi