# Statusblog

Statusblog is an open-source and self-hostable status and incident communication tool.
You can self-host Statusblog or have us run it for you in the cloud.
Here is the [live demo](https://meta.statusblog.io) of our own status blog for statusblog.io.

## Why Statusblog?

There are many status page and incident communication tools out there. We have detailed comparisons
between ourselves and each of them on [our website](https://statusblog.io/alternatives/). Here's what
makes Statusblog different:

* **Open-source** - The core functionality of Statusblog is open source, allowing you to modify it as you want and to self-host it yourself. We think the incident communication tools you use should be as open as the monitoring tools or web frameworks you use to power your business.
* **Not dependent on buidlers** - Many newer status page are fully static and depend on GitHub Actions to build their site when they update their repository, which [often](https://www.githubstatus.com/incidents/8gsk0zwxzjg2) [go](https://www.netlifystatus.com/incidents/770bh5wppvt1) [down](https://www.githubstatus.com/incidents/cj7gzzj30411). Software, like everything is as strong as its weakest link - we avoid that one.
* **Focused featureset** - Statusblog believes in the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) of doing one thing and doing it well. We focus on incident and status communication so that we excell at precisely that. We think things like website monitoring are better done by the tools you likely already use, like Grafana. 
* **Free custom domain w/ SSL** - If you use our hosted service, you can set up a custom domain with SSL for free. We make money by charging on number of subscribers or team members you use, _not_ by making you fork over monye for a cert we get for free from [Let's Encrypt](https://letsencrypt.org/).
* **Elixir powered** - Elixir and its Erlang/BEAM base were literally purpose-built for fault-tolerance and many nines of availability. This allows our software to keep crashes and degradations local instead of crashing the entire service. It also allows our software to handle at least a magnitude more load than a Ruby/Rails equivalent.

If you are interested in learning more, check out [our website](https://statusblog.io), read our [about page](https://statusblog.io/about), or explore our [documentation](https://docs.statusblog.io).

## Can Statusblog be self-hosted?

All the code in this repository is the exact code we use to host [Statusblog.io](https://statusblog.io), so you can use it to self-host it yourself.

As Statusblog is still under _rapid_ development, self-hosting does not current have any backwards-compatible guarantees or semantic versioning labeling.
We think self-hosting is an important part of growing the community around Statusblog, and hope to stabilize things and provide a more streamlined self-hosting
process and documentation in the near future.s

## Applications and code layout

Statusblog is structured as an Elixir umbrella project with multiple applications:

* **apps/statusblog** - The core that powers it all.
* **apps/statusblog_web** - The admin panel for creating and managing your blogs and incidents
* **apps/statusblog_site_web** - The public-facing web app for showing your status blogs to the world
* **apps/statusblog_marketing_web** - The code that powers our [statusblog.io](https://statusblog.io) homepage. You probably don't need this!

## Licenses

As mentioned in our [LICNESE](LICENSE) file, the admin panel and marketing site are both licensed under the [BSL license](LICENSE_BSL).
Everything else is licensed under the [Apache 2.0 License](LICENSE_APACHE). 

The Business Source License 1.1 is an eventually-open-source license. It does not fit the OSI definition of open source because of the restriction
it places is that you can't take the code and create a competitor to our [Statusblog.io](https://statusblog.io) service using that code. That
same restriction, however, expires in 3 years, meaning all code licensed in this way reverts to the Apache 2.0 License after 3 years.

We use the BSL license for some of our code so that we can to keep our open code and software sustainable. Ultimately, open source is not a business model,
it is a software development methodology. We strive to keep our code as open as possible so you can use it more or less however you want,
while adding the minimal restrictions to allow us to sustainably grow both the service and the software. 
