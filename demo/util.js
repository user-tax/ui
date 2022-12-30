export const doc = document,
	{ assign } = Object,
	byTag = (tag, next) => {
		for (const i of doc.getElementsByTagName(tag)) {
			next(i);
		}
	},
	onClick = (elem, func) => {
		elem.onclick = function (e) {
			e.preventDefault();
			func.call(this, e);
		};
	};
