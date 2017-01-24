# How to import the sample vRA blueprints and set up Event Broker

## Sample Blueprints

* PE Linux Webserver Example
* PE Windows Webserver Example

### It's easy to import these blueprints into vRA with CloudClient.

https://developercenter.vmware.com/tool/cloudclient/

```
===================================================
 _____ _                 _ _____ _ _            _
/  __ \ |               | /  __ \ (_)          | |
| /  \/ | ___  _   _  __| | /  \/ |_  ___ _ __ | |_
| |   | |/ _ \| | | |/ _` | |   | | |/ _ \ '_ \| __|
| \__/\ | (_) | |_| | (_| | \__/\ | |  __/ | | | |_
 \____/_|\___/ \__,_|\__,_|\____/_|_|\___|_| |_|\__|


===================================================
Version : 4.1.0
*Tip* : You can hit tab to move through commands and arguments

Welcome to the VMware CloudClient
```

### Blueprint install - some favorite commands

Start with `help` to get an overview, and then try these:

Create an autologin file then quit and edit the file. Provide the credentials for your vRA tenant and your IaaS server. I use username/password and don't use keyfile. I don't provide vRO creds, but you could. When you open CloudClient again, you'll be logged in automatically. You can do this interactively as well, but the file is easier.
```
CloudClient>login autologinfile
```

This will import a sample blueprint in the current directory into your vRA tenant.
```
CloudClient>vra content import --path ./PELinuxWebserverExample-composite-blueprint.zip --resolution OVERWRITE --precheck OFF
```

This will show you the properties, property groups, and blueprints that you have in vRA.
```
CloudClient>vra content list
```

### Event Broker Subscriptions - you just need two

* Install PE Agent
* Purge PE Agent

After you import blueprints, you'll want to configure Event Broker to call the Install or Purge actions for the MachineProvisioned and UnprovisionMachine events under Administration > Event Broker > Subscriptions. When you request a blueprint from the catalog, the VM built will go through lifecycle stages like "Cloning" and "Customize Machine". When the VM reaches the right stage during initial provisioning or when being destroyed, you'll want the right vRO workflow to run to make sure Puppet configures your machine or the node is cleaned up in Puppet (releasing the license and removing the node from the management console). Make sure you "Publish" your subscriptions once you're done or they won't be active.

Create a new "Install PE Agent" subscription under event topic "Machine Provisioning", and then on the "Conditions" tab, "Run Based on Conditions" for "All of the following" with two clauses:
* [Data > Lifecycle state > Lifecycle stage name] [Equals] [(Constant) VMPSMasterWorkflow32.MachineProvisioned]
* [Data > Lifecycle state > State phase] [Equals] [(Constant) PRE]

Then on the "Workflow" tab, connect it to the vRO workflow:
*  "Library > Puppet > Event Broker Samples > EventBroker Install PE agent

Create a new "Purge PE Agent" subscription under event topic "Machine Provisioning", and then on the "Conditions" tab, "Run Based on Conditions" for "All of the following" with two clauses:
* [Data > Lifecycle state > Lifecycle stage name] [Equals] [(Constant) VMPSMasterWorkflow32.UnprovisionMachine]
* [Data > Lifecycle state > State phase] [Equals] [(Constant) PRE]

Then on the "Workflow" tab, connect it to the vRO workflow:
*  Library > Puppet > Event Broker Samples > EventBroker Purge PE Agent Node

### Noteworthy Points

##### Catalog Management
These blueprints should be "published" once you import them, but you need to ensure that they are "Active" and available to the desired "Service" in your tenant.
* Administration > Catalog Management > Catalog Items > PE Linux Webserver Example
* Administration > Catalog Management > Catalog Items > PE Windows Webserver Example

##### Blueprint Generalization
These blueprints are self-contained, and have all poperties exposed, but normally I'd hide some properties from end users and use vRA Property Groups to DRY things up a bit. For example a Property Group with the State Changes for Event Broker, one for Linux SSH creds, one for Windows WinRM creds, one for Autosign secret. Properties like the Puppet.AutoSign.SharedSecret have values that work out of the box with the content at https://github.com/puppetlabs/puppet-vro-starter_content. To put the final polish on, you will also want to create Property Definitions so you can have pretty display names, dropdowns, input validation, etc. All of this stuff is under:
* Administration > Property Dictionary.
