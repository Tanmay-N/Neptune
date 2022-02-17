
# Neptune The Recon Tool

 Neptune is a script written in Bash. it is intended to automate some tedious tasks of reconnaissance and information gathering 

# Main Features
- Create a dated folder with recon notes 

- Grab subdomains using: (Directory search module is now MULTITHREADED (up to 10 subdomains scanned at a time))
```
crt, warchive, amass, subfinder, threatcrowd, hackertarget, virustotal, gau, dnsbuffer, certspotter, anubisdb, alienvault, urlscan, threatminer, riddler, dnsdumpster, rapiddns
```

- Find any CNAME records pointing to unused cloud services like aws

- Probe for live hosts over ports 80/443

- Grab a screenshots of responsive hosts

- Scrape wayback for data:

    * Extract javascript files
    * Build custom parameter wordlist, ready to be loaded later into Burp intruder or any other tool
    * Extract any urls with .jsp, .php or .aspx and store them for further inspection

- Perform nmap on specific ports

- Get dns information about every subdomain

- Check vulnerabilities like HTTP request smuggling, AEM vulnerabilities.

- Improved reporting and less output while doing the work

# Installation & Requirements

* Run installation Script 
 ```
 .\install.sh 
 ```

 **Warning:** This code was originally created for personal use, it generates a substantial amount of traffic, please use with caution.

