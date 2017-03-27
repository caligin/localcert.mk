# localcert.mk

A Makefile include to handle localhost certificates. Be prod like, enable TLS locally.

Often webapp projects are implemented with weird exceptions and complicated config switches to change the running and testing behaviour locally as we don't have/don't want to set up certificates and https (think cookies and `httpOnly` flags...). This make include aims to ease the process of generating and trusting certificates to help getting rid of some accidental complexity caused by non-prod-like setups.

For now it mainly supports JVM-based applications by generating a Java keystore.

## Requirements

To generate:
- `keytool`
- `openssl`

To also manage trust:
- `certutil`

## Usage

Grab `localcert.mk` from Github's raw link and place it next to your `Makefile` (or in the root of your project if you don't have a `Makefile`).

Then if you're already using make, add the following line to your `Makefile`:
```
include localcert.mk
```
if you're not using make, create a `Makefile` containing that line only.

### Targets to invoke

#### `trust-localcert`

Adds the local certificate to the system trust stores (a.k.a. Chrome will see the page as "green" and not a red security warning)

#### `untrust-localcert`

Removes the certificate from the system trust stores.

#### `gitignore-localcert`

Echoes the lines to add to `.gitignore` to ignore the generated keystore and cert files.

### Targets to depend on

#### `$(LOCALCERT_KEYSTORE)`

Depending on this target will ensure that the keystore is created before proceeding. I.e. before running your app:

```
run: my-jar-that-uses-a-keystore.jar $(LOCALCERT_KEYSTORE)
	java -jar $<
```

#### `$(LOCALCERT_CERT)`

Depending on this target will ensure that the cert is created before proceeding.

This target depends on the `$(LOCALCERT_KEYSTORE)` target.

## Testing

`./test.sh`

## Configuring

You can configure some parameters by assigning the variables in your `Makefile` before the `include` line. I.e:

```
PROJECT := myproj
include localcert.mk
```

The following variables are available for configuration:

#### `PROJECT`

Name of the project. Defaults to the name of the directory containing the `Makefile`.

The project name prefixes all generated filenames and aliases.

#### `LOCALCERT_PASSWORD`

Password to keystore and private key. Defaults to `correct horse battery staple` ([obligatory xkcd](https://xkcd.com/936/)).

## Other interesting considerations

### Security & trust boundaries

Well trusting self-signed certificates is not exactly considered best practice.

Part of the problem though is that often developers find the interface of `keytool` and `openssl` unfriendly and once generated a self-signed cert for internal use it's either shared wildly or committed in some shared git repo, causing an immediate invalidation of any trust you can have on the ownership of the cert and its keys.

The thinking behind `localcert.mk` is that by making it easy to generate, regenerate and throw away a local certificate we avoid the sharing problem, thus retaining the trust within the boundary of the local machine.

So yeah, don't share that cert or it's game over.

### But I can have https with some nginx in dockerdockerdocker!

I know it's 2017 but we're not all lucky enough to be dockering all the time. Sometimes you need to do it with fairly vanilla tools because constraints.

### I don't like make. Why make and not gradle|rake|npm|docker|whiteboard ?

Make might have a fairly arcane syntax and a steep learning curve, but it's widely available and it's good at combining different tools together while ensuring that stuff is not done twice when you don't need to.

### This looks just for java and your tests are ugly (a.k.a. Contributing)

This is what you get for a-night-and-a-train-ride hack. If you have hints, complaints or find a bug open a ticket!

I hope that the concepts prooves good enough to give me an excuse to invest some time expanding it. If you have some good ideas and/or want to help expand the project send a PR!

