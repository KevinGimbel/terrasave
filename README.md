# terrasave
>  A tiny protective layer on top of terraform

<!-- BEGIN mktoc -->
- [Why does this exist?](#why-does-this-exist)
- [Installation](#installation)
  - [Bash & zsh](#bash--zsh)
    - [Bash](#bash)
    - [Zsh](#zsh)
  - [Fish](#fish)
- [Usage](#usage)
  - [What is `-target`? ](#what-is--target)
  - [Running `apply` without a target](#running-apply-without-a-target)
- [Contributing](#contributing)
  - [Where to start?](#where-to-start)
- [Code of Conduct](#code-of-conduct)
- [License](#license)
<!-- END mktoc -->

## Why does this exist?

In terraform it is incredibly easy to destroy things with `terraform apply`. If you run `apply` terraform shows a huge output and sometimes you may overlook a thing being "replaced" instead of updated. Once upon a time I destroyed a MongoDB Atlas Cluster this way and lost all its data, because the "must be replaced" was hidden in a lot of terraform output and I simply didn't see it. I only realized when terraform logged "Still destroying cluster..." to the console.

Some terraform resources, like Amazon ECS Services, are not idempotent, so they change on every apply. This cluttered my terminal with stuff I could ignore on every change as well as unnecessary updates to the infra (ECS Services being replaced despite no changes were made).  

To prevent this, I forced myself to only use terraform with the `-target` switch, and this tiny script helps me accomplish that.

## Installation

### Bash & zsh

In Bash and zsh, a function named `terraform_save` is created which is then assigned with an alias to `terraform`, so whenever `terraform` is run it is executed "through" the bash function.

Install it by adding the function and alias to a shell config file like `.bashrc` or `.bash_profile`.

#### Bash
```bash
# ~/.bashrc
$ cat terraform.bash >> ~/.bashrc
# OR ~/.bash_profile
$ cat terraform.bash >> ~/.bashrc
```

#### Zsh

```bash
$ cat terraform.bash >> ~/.zshrc
```

### Fish

Copy or link `terraform.fish` into your fish config directory.

**Copy**
```bash
$ cp terraform.fish ~/.config/fish/functions/terraform.fish
```

**Link**

```bash
$ ln -s (pwd)/terraform.fish ~/.config/fish/functions/terraform.fish
```

## Usage

The script creates an alias so you can use terraform just like you would. It's a drop-in tool. 

1. Install as described above
2. Run `terraform apply`
3. The script will tell you to run `terraform apply` with `-target` set
4. Run `terraform apply -target=module.my_thing" 
5. 💶💶💶

### What is `-target`? 

`-target` is a terraform option that allows you to only run terraform on a subset of resources. Consider the following example.

```hcl

module "my-module" {
  source = "git::git@github.com:someorg/somemodules?ref=1.0"
}


module "my-other-module" {
  source = "git::git@github.com:someorg/somemodules?ref=1.0"
}
```

If you run `terraform apply` both `my-module` and `my-other-module` are provisioned. Depending on what the modules do there may be a lot of output on the CLI and it'll be very hard to go through all the stuff. We can make our live easier by using `-target` to deploy one after the other.

```bash
$ terraform apply -target=module.my-module
```

This will only provision the resources defined in `my-module`.

You can find out more in the terraform docs in the sections about [the apply command](https://www.terraform.io/docs/commands/apply.html#target-resource) and [resource naming and addressing](https://www.terraform.io/docs/internals/resource-addressing.html).

### Running `apply` without a target

Of course you'll sometimes want to run apply without a target, for example when bootstrapping a new project. In this case you can execute the script with the `TERRAFORM_SAVE_DISABLE_I_KNOW_WHAT_I_DO` variable set to 1.


```bash
$ TERRAFORM_SAVE_DISABLE_I_KNOW_WHAT_I_DO=1 terraform apply
```

You can also export the variable for the current shell in fish or `bash`/`zsh`

`bash` and `zsh`

```bash
$ export TERRAFORM_SAVE_DISABLE_I_KNOW_WHAT_I_DO=1
$ terraform apply
```

And for `fish`

```bash
$ set -x TERRAFORM_SAVE_DISABLE_I_KNOW_WHAT_I_DO 1
$ terraform apply
```


## Contributing

We love and welcome every form of contribution, be it code, documentation, or management (issues, answering questions, etc.).

### Where to start?

Here are some good places to start:

* Issues with label [Good first issue](https://github.com/kevingimbel/terrasave/labels/good%20first%20issue)
* Issues with label [Documentation](https://github.com/kevingimbel/terrasave/labels/documentation)
* Translating documentation

## Code of Conduct

You are expected to follow our [code of conduct](https://github.com/kevingimbel/terrasave/blob/master/CODE_OF_CONDUCT.md) when interacting with the project via issues, pull requests or in any other form. Many thanks to the awesome [contributor covenant](https://www.contributor-covenant.org/) initiative!

## License

See LICENSE file.