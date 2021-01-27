## Browse and Discover Lights API

Sinatra API to store disovered lights and fetch users who have seen the same lights.

I work quite a lot in private repositories, but this public repository can be used for some future internal and external blog as examples and sections to point towards.

If you want to you can clone this repository and run it for yourselves with the included scripts to rule them all.

A few use cases you can use this project for:
- As reference for blogs or certain practices
- As boilerplate for new projects
- To build an app to register devices (in this case lights) you found nearby
- To find out who have seen the same devices (lights) recently as the user using your app
- To find out which users were nearby based on mutual recent discovered devices
- Use to match users' locations without the need for GPS; In this project lights are used as example, but if you send in all kinds of devices like router addresses or discovered phones you basically can determine who you were nearby recently. Sidenote is that client SDK's do not always offer good ways of listing mac addresses of all nearby devices, but you should be able to get far by listing router mac addresses.

### Bootstrapping the project
`script/bootstrap`

### Tests
`script/test` or for individual tests `bundle exec rspec #{path}` or `bundle exec cucumber #{path}`.

### Server
Prerequirement: Make sure you have postgress locally available (optionally hosted in Docker)

`script/server `          (with ngrok `ngrok http 9292 -subdomain=browse`)
