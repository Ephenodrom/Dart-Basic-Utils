# DomainUtils

Lorem

## Examples

### Foo

```dart

```

## All methods

```dart
bool isDomainName(String s);
bool isSubTld(String tld, String subTld);
bool isSubDomain(String s);
bool isSubDomainOf(String sub, String domain);
bool isCCTLD(String s);
bool isNGTLD(String s);
bool isTld(String s);
bool isGTLD(String s);
List<String> splitDomainName(String domainName);
Domain getDomainFromUrl(String url);
Domain parseDomain(String domainName);
List<String> splitSubdomainInDomains(String name);
```
