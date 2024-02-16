# English

## redact
To help prevent accidental disclosure, GitHub Enterprise Cloud uses a mechanism that attempts to redact any secrets that appear in run logs.. This redaction looks for exact matches of any configured secrets, as well as common encodings of the values, such as Base64.

GitHub Actionsがシークレットがログに表示されるとき、マスキングするみたいな文脈で。

## method
In many cases, especially in the beginning of a project, SSH agent forwarding is the quickest and simplest method to use.

方法は、ほぼmethodと考えてよい

## essentially
Tokens are essentially passwords, and must be protected the same way.

GheのOAuth tokensのところでの留意事項みたいな形で出てくる。本質的にとか、言っちゃえば的な？

## 

# Japanes


# another memo
## SSh forawarding
ssh -A user-name@example.com
-A をつけると、ssh-agentの認証を飛ばせる

-A オプションの代わりに ~/.ssh/config で ForwardAgent yes と指定することで同じ効果を得ることができます。

```
Host example.com
    ForwardAgent yes
```
