# Release History

* 20180626, V0.9.5
    * Stability: Replaced jsdom/jquery with cheerio which provides better performance and less memory usage

* 20180301, V0.9.4
    * Stability: Call window.close() to make sure dom resources will be fully released
    * Stability: Removed obsolete timer code

* 20171118, V0.9.3
    * Fixture: Improved handling of precipitation readings
    
* 20171108, V0.9.2
    * Downgraded jsdom package to workaround node.js v4 build issue
    
* 20171107, V0.9.1
    * Use column headers to access data fields as the number 
      and ordering of columns can vary, issue #2
    * Dependency updates
    
* 20170225, V0.9.0
    * Initial version