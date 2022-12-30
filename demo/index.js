import { waySet } from "../auth/WAY.js";
import MAIL from "../auth/WAY/MAIL.js";
waySet(MAIL);

import "./i18n.js";

import { assign, doc, onClick } from "./util.js";
import { uName, uAuth, uIfUser } from "../index.js";
import On from "../lib/On.js";
import Box from "../Box.js";
import { getLang } from "../I18n.js";
import { byTag0 } from "../lib/byTag.js";

const initAuth = (form, next) => {
		assign(form, {
			agree: async () => {
				const dialog = Box(
						'<div style="padding:0 1.8em 2em;height:calc(100vh - 8em);"><b style="height:100%;justify-content:center;display:flex;align-items:center"><svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 100 100"><circle cx="50" cy="50" fill="none" stroke="#ccc" stroke-width="10" r="35" stroke-dasharray="164.93361431346415 56.97787143782138"><animateTransform type="rotate" repeatCount="indefinite" dur="1s" values="0 50 50;360 50 50" keyTimes="0;1" attributeName="transform"/></circle></svg></b></div>',
					),
					[md] = await Promise.all([
						(async () =>
							(
								await fetch(`//law.user.tax/${getLang()}/user`)
							).text())(),
						import(
							"//lf6-cdn-tos.bytecdntp.com/cdn/expire-1-M/marked/4.0.2/marked.min.js",
						),
					]);
				dialog.lastChild.innerHTML = marked.parse(md);
				dialog.style = "width:85vw;max-width:750px";
			},
		});
		if (next) form.next = next;
		return form;
	},
	boxAuth = (e) => {
		const box = Box(
			'<div class="auth"><header><b class="logo"></b><b class="org"><b>User.Tax</b><b><i-slogan></i-slogan></b></b></header><u-auth></u-auth></div>',
		);

		initAuth(byTag0(box, "u-auth"), box.close.bind(box)).up =
			"up" == e?.target.className;
		return box;
	};

initAuth(byTag0(doc, "u-sign")).auth = boxAuth;

byTag0(doc, "u-menu").auth = (sign) => {
	initAuth(sign).auth = boxAuth;
};

doc.querySelectorAll("u-menu a").forEach((e) => onClick(e, boxAuth));
