This is to demonstrate the issue with Passenger Standalone detailed at https://github.com/phusion/passenger/issues/2038

Usage:
```bash
docker build -t passenger-test .
docker run --rm -p 3000:3000 passenger-test
```
Then, in browser, hit http://localhost:3000/packs/application-8d71e5035f8940a9e3d3.js