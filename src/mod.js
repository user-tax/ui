import { sdkConf as _sdkConf } from "./lib/SDK.js";

export const sdkConf = (...args) => {
	uCaptcha();
	uAlter();
	uMenu();
	uConf();
	uIfUser();
	uAuthMailCode();
	uResetPassword();
	uSign();
	uName();
	_sdkConf(...args);
};
