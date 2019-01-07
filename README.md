LSST SQRE terragrunt production
===

`terragrunt`/`terraform` driven deployment(s) of LSST SQRE production services.

** Note that
[`terragrunt-live-test`](https://github.com/lsst-sqre/terragrunt-live-test)
should be used to manage LSST SQRE dev/test/stage deployments.**

Usage
---

```bash
make all tls
export PATH="${PWD}/bin:${PATH}"
cd prod/gitlfs
terragrunt apply
```

Prod Deployments
---

- [`efd-kafka`](prod/efd-kafka)
- [`gitlfs`](prod/gitlfs)

See Also
---

* [`terraform`](https://www.terraform.io/)
* [`terragrunt`](https://github.com/gruntwork-io/terragrunt)
