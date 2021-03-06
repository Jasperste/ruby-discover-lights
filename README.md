## Browse and Discover Lights API
[![Main](https://github.com/jasperste/ruby-discover-lights/workflows/CI/badge.svg)](https://github.com/jasperste/ruby-discover-lights/actions)

API to store discovered light entities, based on their mac addresses, and fetch users who have seen the same lights.

This repository will and can be used for some upcoming blogs and internal presentations as examples and sections to point towards. I currently do most contributions to private repository, but started this repository to give a public insight into some specific coding sections and structuring.

If you want to you can clone this repository and run it for yourselves with the included 'scripts to rule them all'.

A few use cases you can use this project for:
- As reference for blogs or certain practices
- As boilerplate for new projects
- To build an app to register devices (in this case lights) you found nearby
- To find out who have seen the same devices (lights) recently as the user using your app
- To find out which users were nearby based on mutual recent discovered devices
- To use to match users' locations without the need for GPS; In this project lights are used as example, but if you send in all kinds of devices like router addresses or discovered phones you basically can determine who you were nearby recently. Sidenote is that client SDK's do not always offer good ways of listing mac addresses of all nearby devices, but you should be able to get far by listing router mac addresses.

### Bootstrapping the project
Prerequirement: Make sure you have postgress locally available (optionally hosted in Docker)

`script/bootstrap`

### Tests
`script/test` or for individual tests `bundle exec rspec #{path}` or `bundle exec cucumber #{path}`.

### Server
`script/server `          (with ngrok `ngrok http 9292 -subdomain=browse`)
