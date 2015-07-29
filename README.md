![PFSystemKit logo, Apple-style][logo]

![PFSystemKit features][features]

#### OSX Framework for getting system informations
OS X (and partially iOS) framework for getting software and hardware informations (such as CPU vendor, RAM size, device model and serial, …) at runtime. Relies on IOKit and SysCtl, as well as on the now-deprecated GestaltManager, for compatibility purposes only.

Here's what you can gather with PFSystemKit:
* CPU informations (vendor, nominal clock speed, caches size, core count, thread count, marketing name)
* RAM infos (size, usage statistics)
* GPU infos (matching framebuffer, model, ports)
* Device infos (device family (e.g. MacBook Pro), model (MacBookPro8,1), version (8,1), serial)
* Battery (voltage, current, serial, manufacturer, age in days, cycle count, temperature)

#### Help
You can help ? Don't be shy, pull requests welcome !
Otherwise, just open an issue, I'll take a look in it.

#### Roadmap
* Cocoapods and Carthage support
* GPU informations enhancements
* Better iOS support

## License (MIT)
* Copyright © 2015 Perceval [**@perfaram**](https://github.com/perfaram) FARAMAZ
* Portions Copyright © 2013 John Winter (john@aptonic.com)
* Portions Copyright © 2012 PHPdev32 (firewater2311@yahoo.com)
* Portions Copyright © 2008 "Matt" (from Apple-dev mailing list)
* Portions Copyright © 2009 Sahil [**@sahil**](https://github.com/sahil) Desai
* Portions Copyright © 2010 Richard [**@rickmark**](https://github.com/rickmark) Penwell
* Portions Copyright © 2014 Jake [**@jakepetroules**](https://github.com/jakepetroules) Petroules
* Portions Copyright © 2009 The Contributors of the Chromium Project

> The MIT License (MIT)
> Copyright (c) 2015 Perceval [**@perfaram**](https://github.com/perfaram) FARAMAZ

> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.

--------
###### Published in the hope that it will be useful

[logo]: https://raw.githubusercontent.com/perfaram/PFSystemKit/master/logo.png?token=ABntO4wgFbPCjuxGaZDKJfgRrAn8gtUIks5Vi6XuwA%3D%3D "PFSystemKit"
[features]: https://raw.githubusercontent.com/perfaram/PFSystemKit/master/Features.png?token=ABntO9Sr-HblgH04oy3YLH9U8c-KaAzwks5Vi7ZVwA%3D%3D "Features"
