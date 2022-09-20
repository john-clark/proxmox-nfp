# Still looking at this

## They really need to fix this

- Community edition should not be $100 a core per year just to remove this stupid nag

One version
```
sed -i.backup -z "s/res === null || res === undefined || \!res || res\n\t\t\t.data.status.toLowerCase() \!== 'active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```

Another
```
$ cd /usr/share/javascript/proxmox-widget-toolkit/

# create a backup of you proxmoxlib.js
$ cp proxmoxlib.js proxmoxlib.js.oem

# edit proxmoxlib.js
$ vi proxmoxlib.js

# Search for
Ext.Msg.show({
  title: gettext('No valid subscription'),

# Replace with
void({
  title: gettext('No valid subscription'),

# Restart preproxy service
$ systemctl restart pveproxy.service

# To Check ( it'ss working or not )
$ grep -n -B 1 'No valid sub' proxmoxlib.js
```

And another
https://github.com/rickycodes/pve-no-subscription/blob/main/no-subscription-warning.sh

# Mine
vi /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
```
checked_command: function(orig_cmd) {
        Proxmox.Utils.API2Request(
            {
                url: '/nodes/localhost/subscription',
                method: 'GET',
                failure: function(response, opts) {
                    Ext.Msg.alert(gettext('Error'), response.htmlStatus);
                },
                success: function(response, opts) {
                    let res = response.result;
                //    if (res === null || res === undefined || !res || res
                //      .data.status.toLowerCase() !== 'active') {
                //      Ext.Msg.show({
                //          title: gettext('No valid subscription'),
                //          icon: Ext.Msg.WARNING,
                //          message: Proxmox.Utils.getNoSubKeyHtml(res.data.url),
                //          buttons: Ext.Msg.OK,
                //          callback: function(btn) {
                //              if (btn !== 'ok') {
                //                  return;
                //              }
                //              orig_cmd();
                //          },
                //      });
                //    } else {
                        orig_cmd();
                //    }
                },
            },
        );
    },
```