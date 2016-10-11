# Alpha Delta Phi - Lambda Phi

This is the internal web app used by Alpha Delta Phi - Lambda Phi chapter at MIT to manage its internal affairs and documents. Currently it has the following features: 

* Manage a directory of pledge classes as well as brothers - including personal information, officer positions, etc. 
* Event (including house meetings) attendence tracking. 
* Social, kitchen, and house job balance tracking. 
* A personal page for each brother summarizing all the above information. 

## Repo Ground Rules

1. Do NOT `git push --force` (at least not on branches that other people are also working on, including `master`). 
2. Use feature branches for implementing features (naming convention `issue-xx`, where `xx` is the corresponding GitHub issue number). Minor fixes can go into master directly. 
3. Submit Pull Requests for merging feature branches into `master`. Do NOT merge your own Pull Requests without other people reviewing the code first. 

## Dependencies

Everything in `Gemfile`. 

## Development

Development environment for this app is a typical Rails development environment. After cloning the repo, edit config/database.yml to match your database configuration, and run the following commands to start the server: 

```bash
$ bundle install
$ rake db:migrate
$ rails server
```

Then you can run the following rake task to import some initial data to get you started: 

```bash
$ rake import:all
```

