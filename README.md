Dependencies:

- [Stack](https://www.haskellstack.org)
- [npm](https://www.npmjs.com/)

To build this site locally:

- Clone the `develop` branch of this repo to a local dir, and `cd` into it.
 
~~~
git clone -b develop --singlebranch https://github.com/patrl/selectionfest.git
cd selectionfest
~~~

- Setup the haskell environment with stack.

~~~
stack init
stack setup
stack build
~~~

- Install the javascript dependencies with npm.

~~~
npm install
~~~

- Build the site and host at a local server:

~~~
stack exec site build
stack exec site watch
~~~


