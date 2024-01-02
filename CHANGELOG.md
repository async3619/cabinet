## 1.0.0 (2024-01-02)


### Features ✨

* **home:** add registered watcher list on home screen ([#4](https://github.com/async3619/cabinet/issues/4)) ([43c6b29](https://github.com/async3619/cabinet/commit/43c6b29a7e5962db286c01ff7444b4bdbbb40dba))
* **media:** add gallery view for all images of post list items ([#56](https://github.com/async3619/cabinet/issues/56)) ([fde0651](https://github.com/async3619/cabinet/commit/fde0651bf5b92ec1ce72881e2b4a8ae3b7a22519))
* **media:** implement save media into external storage feature ([#40](https://github.com/async3619/cabinet/issues/40)) ([91c54e8](https://github.com/async3619/cabinet/commit/91c54e8798b5188856a0a31b200d695a36cb93af))
* **post:** implement post excluding from crawling feature ([#27](https://github.com/async3619/cabinet/issues/27)) ([8f871fb](https://github.com/async3619/cabinet/commit/8f871fb5ba81f1b33c8489888669a90d58eadefc))
* **post:** implement post viewer feature ([#8](https://github.com/async3619/cabinet/issues/8)) ([5384e10](https://github.com/async3619/cabinet/commit/5384e1043d0de94f8a484c702766dcc73cec8d31))
* **post:** implement show post replies feature ([#36](https://github.com/async3619/cabinet/issues/36)) ([aa476f2](https://github.com/async3619/cabinet/commit/aa476f203f51a943ce52193d6884036aff378613))
* **post:** now post list view widget will show whether if post is archived or not ([#50](https://github.com/async3619/cabinet/issues/50)) ([a5ce7ce](https://github.com/async3619/cabinet/commit/a5ce7cebfbd045d6870caeb6fc2adae28297a887))
* **post:** now post thread list scroll is synced with current watching media ([#35](https://github.com/async3619/cabinet/issues/35)) ([557225a](https://github.com/async3619/cabinet/commit/557225ac146fcdefd1ebc43e28b0a9596ccec775))
* **post:** now posts are able to determine if all children are read or not ([#54](https://github.com/async3619/cabinet/issues/54)) ([b14b8f3](https://github.com/async3619/cabinet/commit/b14b8f3346c2f6d8413d2dad087b1cea3d12e67f))
* **posts:** implement posts filtering by boards feature ([#22](https://github.com/async3619/cabinet/issues/22)) ([1a1d425](https://github.com/async3619/cabinet/commit/1a1d425a28d31d3f328cdd45b7e810ba01199e5a))
* **posts:** implement posts filtering by watchers feature ([#20](https://github.com/async3619/cabinet/issues/20)) ([248adf0](https://github.com/async3619/cabinet/commit/248adf0490ed14dee5ea542d3da53ae90a520dcd))
* **posts:** make posts list filtering option to be persisted ([#24](https://github.com/async3619/cabinet/issues/24)) ([c265201](https://github.com/async3619/cabinet/commit/c265201e014820b576bb842a47f9537bf2866292))
* **posts:** make posts list to be able to sort order ([#17](https://github.com/async3619/cabinet/issues/17)) ([ceab72c](https://github.com/async3619/cabinet/commit/ceab72c5c0246ec871c40abf2dc105b8b3747a18))
* **watcher:** implement background watcher runner ([#10](https://github.com/async3619/cabinet/issues/10)) ([ff28e37](https://github.com/async3619/cabinet/commit/ff28e3797b94f228c37961e8935c2946d5d264f4))
* **watcher:** implement creating watcher feature ([#2](https://github.com/async3619/cabinet/issues/2)) ([42f4a8b](https://github.com/async3619/cabinet/commit/42f4a8ba376e43daa2a2a9fa748d774f86b2fc39))
* **watcher:** implement excluding feature for watcher filters ([#37](https://github.com/async3619/cabinet/issues/37)) ([8d962b9](https://github.com/async3619/cabinet/commit/8d962b938ce853590a9adb89e606da79832c2c3a))
* **watcher:** make watcher can be executed ([#6](https://github.com/async3619/cabinet/issues/6)) ([9193324](https://github.com/async3619/cabinet/commit/9193324687168614a8c68b4eef487f51ea59a6cb))
* **watcher:** now watcher can crawl for archived posts ([#39](https://github.com/async3619/cabinet/issues/39)) ([274a02d](https://github.com/async3619/cabinet/commit/274a02d3633aaac577f82b641402ea11a33b3d5b))
* **watcher:** now watcher can specify crawling interval ([#33](https://github.com/async3619/cabinet/issues/33)) ([73e5e0e](https://github.com/async3619/cabinet/commit/73e5e0e414a7a8a2f54e39b95a8df421a029aa22))
* **worker:** now background worker will leave a execution log ([#44](https://github.com/async3619/cabinet/issues/44)) ([e210109](https://github.com/async3619/cabinet/commit/e21010960061d6ea73e0967386e65eeb66dfff28))


### Bug Fixes 🐞

* **media:** make exported media saved into download path ([#52](https://github.com/async3619/cabinet/issues/52)) ([30ea7bc](https://github.com/async3619/cabinet/commit/30ea7bcb987fbfe5cb6f156ff18efedbd135e5d6))
* **post:** fix a bug that post title was not html unescaped ([#14](https://github.com/async3619/cabinet/issues/14)) ([25078d8](https://github.com/async3619/cabinet/commit/25078d878aa29d212963ccc87eb2320b8dd3153e))
* **posts:** now html codes on post list item content will be trimmed ([#26](https://github.com/async3619/cabinet/issues/26)) ([a37a757](https://github.com/async3619/cabinet/commit/a37a757fa10e4e402937bcc86d8d6ca8ab824306))
* **watcher:** fix a bug that watchers storing duplicated archived post data ([#42](https://github.com/async3619/cabinet/issues/42)) ([ea309b6](https://github.com/async3619/cabinet/commit/ea309b6f4b93f46a0e1a321d1bf92366373e59b5))
* **worker:** fix a bug that watchers terminated by reading deleted archived thread ([#49](https://github.com/async3619/cabinet/issues/49)) ([6be6c70](https://github.com/async3619/cabinet/commit/6be6c70c67dfc0f5fc2722c909048f7742f49cdd))


### Internal 🧰

* **background-worker:** now background worker leaves error message if it was failed ([#47](https://github.com/async3619/cabinet/issues/47)) ([f91c402](https://github.com/async3619/cabinet/commit/f91c4026f2be917be7f892a32f8ce7c838cf3956))
* change title bar text into app name ([3792ca1](https://github.com/async3619/cabinet/commit/3792ca10f9438a3d0b05ddd3e3c62f53d91eb100))

## [1.0.0-dev.3](https://github.com/async3619/cabinet/compare/v1.0.0-dev.2...v1.0.0-dev.3) (2024-01-02)


### Features ✨

* **media:** add gallery view for all images of post list items ([#56](https://github.com/async3619/cabinet/issues/56)) ([fde0651](https://github.com/async3619/cabinet/commit/fde0651bf5b92ec1ce72881e2b4a8ae3b7a22519))
* **post:** now post list view widget will show whether if post is archived or not ([#50](https://github.com/async3619/cabinet/issues/50)) ([a5ce7ce](https://github.com/async3619/cabinet/commit/a5ce7cebfbd045d6870caeb6fc2adae28297a887))
* **post:** now posts are able to determine if all children are read or not ([#54](https://github.com/async3619/cabinet/issues/54)) ([b14b8f3](https://github.com/async3619/cabinet/commit/b14b8f3346c2f6d8413d2dad087b1cea3d12e67f))


### Bug Fixes 🐞

* **media:** make exported media saved into download path ([#52](https://github.com/async3619/cabinet/issues/52)) ([30ea7bc](https://github.com/async3619/cabinet/commit/30ea7bcb987fbfe5cb6f156ff18efedbd135e5d6))

## [1.0.0-dev.2](https://github.com/async3619/cabinet/compare/v1.0.0-dev.1...v1.0.0-dev.2) (2024-01-02)


### Bug Fixes 🐞

* **worker:** fix a bug that watchers terminated by reading deleted archived thread ([#49](https://github.com/async3619/cabinet/issues/49)) ([6be6c70](https://github.com/async3619/cabinet/commit/6be6c70c67dfc0f5fc2722c909048f7742f49cdd))


### Internal 🧰

* **background-worker:** now background worker leaves error message if it was failed ([#47](https://github.com/async3619/cabinet/issues/47)) ([f91c402](https://github.com/async3619/cabinet/commit/f91c4026f2be917be7f892a32f8ce7c838cf3956))
