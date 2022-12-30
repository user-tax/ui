import { doc, assign, byTag } from "./util.js";
import { uI18n, sdkConf } from "../index.js";
import lang from "../lang.js";
import { Req } from "../lib/req.js";
import getI18n, { I18N_CDN } from "../I18n.js";

uI18n();

var I18N;

class iSlogan extends HTMLElement {
	connectedCallback() {
		if (I18N) {
			this.typed?.destroy();
			const backDelay = 999,
				{ slogan } = I18N,
				typed = (this.typed = new Typed(this, {
					strings: ["", I18N.type, slogan + "^" + 3 * backDelay],
					typeSpeed: 150,
					backSpeed: 45,
					backDelay,
					onComplete: () => {
						typed.destroy();
						delete this.typed;
						this.innerText = slogan;
					},
				}));
		}
	}
}

class i18n extends HTMLElement {
	connectedCallback() {
		if (!this.i) {
			this.i = this.innerText;
			this.innerText = "";
		}
		if (I18N) {
			this.innerText = I18N[this.i];
		}
	}
}

const i18nReq = Req(),
	I18N_LI = [
		["i-slogan", iSlogan],
		["i-18n", i18n],
	];

I18N_LI.forEach((li) => customElements.define(...li));

const I18N_HOOK = [
	/*
   for online product, use :
     I18N(I18N_CDN+lang);
	 if need self host , see https://github.com/user-tax/static
	 for user.tax ui dev, use:
  */
	(lang) => {
		sdkConf("http://127.0.0.1/", lang);
		getI18n("/i18n/" + lang);
	},
	(lang) =>
		i18nReq((o) => {
			I18N = o;
			I18N_LI.forEach((li) => byTag(li[0], (i) => i.connectedCallback()));
		}, `./i18n/${lang}.json`),
];

byTag(
	"u-i18n",
	(elem) =>
		assign(elem, {
			li: lang,
			change: async (lang) => {
				Promise.all(I18N_HOOK.map((f) => f(lang))).finally(() => {
					doc.body.className = "I18N" + lang;
					doc.body.style.display = "";
				});
			},
		}),
);
