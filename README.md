# Imunify Deployment

## Slackstack

### Usage

Clone repo:

```sh
git clone https://github.com/cloudlinux/imunify-deployment.git
```

Copy SLS files to `salt` folder. `/srv/salt` is the default.

Then you can test it with dry run:

```sh
salt host state.apply imunify-install-cpanel test=True
```

Finally, you may run it with dev activation key to see if we successfully configured everything:

```sh
salt host state.apply imunify-install-cpanel pillar='{"activation_key": "<KEY>"}' # for cpanel
salt host state.apply imunify-install-plesk pillar='{"activation_key": "<KEY>", "plesk_license_key": "<PLESK_KEY>"}' # for plesk
```

Accept EULA license and apply configuration:

```sh
salt host state.apply imunify-configuration
```

Or to uninstall:

```sh
salt host state.apply imunify-uninstall
```
