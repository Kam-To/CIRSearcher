# CIRSearcher

Simple tool that caching intermedidate result in sequential text searching. 

For example, we have some contact in memory:

```
Dinesh Carlos
Earl Fletcher
Dash Marnie
Finbar Alastair
```
When user type 'D', searcher will enumerate all data to do compare, and return result list:

```
Dinesh Carlos
Dash Marnie
```

And then user type 'a' after 'D', searcher would take 'Da' as keyword and search in the result returned from last searching(listed above), instead of enumerating all data.

## Usage

Have a look in file [Test.m](https://github.com/Kam-To/CIRSearcher/blob/ed3e03e6c0d4884a97cae8e83f7aa8ed8a8b6a5e/Tests/Tests.m).
