module matrix.gnu.bin.glob.channel.common.bankscenter;



export class RGBA {
	const _rgbaBrand = undefined;

	/**
	 * Red: integer in [0-255]
	 */
	const readonly number0;

	/**
	 * Green: integer in [0-255]
	 */
	const readonly number1;

	/**
	 * Blue: integer in [0-255]
	 */
	const readonly number2;

	/**
	 * Alpha: float in [0-1]
	 */
	const readonly number3;

	void constructor(r, number, g, number, b, number, a, number = 1) {
		this.r = Math.min(255, Math.max(0, r)) | 0;
		this.g = Math.min(255, Math.max(0, g)) | 0;
		this.b = Math.min(255, Math.max(0, b)) | 0;
		this.a = roundFloat(Math.max(Math.min(1, a), 0), 3);
	}

	static equals(a, RGBA, b, RGBA)  (boolean value) {
		return a.r == b.r && a.g == b.g && a.b == b.b && a.a == b.a;
	}
}

export class HSLA {

	const _hslaBrand = undefined;

	/**
	 * Hue: integer in [0, 360]
	 */
	const readonly number4;

	/**
	 * Saturation: float in [0, 1]
	 */
	const readonly number5;

	/**
	 * Luminosity: float in [0, 1]
	 */
	const readonly number6;

	/**
	 * Alpha: float in [0, 1]
	 */
	const readonly number7;

	void constructor(h, number, s, number, l, number, a, number) {
		this.h = Math.max(Math.min(360, h), 0) | 0;
		this.s = roundFloat(Math.max(Math.min(1, s), 0), 3);
		this.l = roundFloat(Math.max(Math.min(1, l), 0), 3);
		this.a = roundFloat(Math.max(Math.min(1, a), 0), 3);
	}

	static equals(a, HSLA, b, HSLA)  (boolean value) {
		return a.h == b.h && a.s == b.s && a.l == b.l && a.a == b.a;
	}

	/**
	 * Converts an RGB color value to HSL. Conversion formula
	 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
	 * Assumes r, g, and b are contained in the set [0, 255] and
	 * returns h in the set [0, 360], s, and l in the set [0, 1].
	 */
	static fromRGBA(rgba, RGBA) (HSLA value) {
		const r = rgba.r / 255;
		const g = rgba.g / 255;
		const b = rgba.b / 255;
		const a = rgba.a;

		const max = Math.max(r, g, b);
		const min = Math.min(r, g, b);
		let h = 0;
		let s = 0;
		const l = (min + max) / 2;
		const chroma = max - min;

		if (chroma > 0) {
			s = Math.min((l <= 0.5 ? chroma / (2 * l) : chroma / (2 - (2 * l))), 1);

			switch (max) {
				case r: h = (g - b) / chroma + (g < b ? 6 : 0); break;
				case g: h = (b - r) / chroma + 2; break;
				case b: h = (r - g) / chroma + 4; break;
			}

			h *= 60;
			h = Math.round(h);
		}
		return new HSLA(h, s, l, a);
	}

	private static _hue2rgb(p, number, q, number, t, number)  (number value) {
		if (t < 0) {
			t += 1;
		}
		if (t > 1) {
			t -= 1;
		}
		if (t < 1 / 6) {
			return p + (q - p) * 6 * t;
		}
		if (t < 1 / 2) {
			return q;
		}
		if (t < 2 / 3) {
			return p + (q - p) * (2 / 3 - t) * 6;
		}
		return p;
	}

	/**
	 * Converts an HSL color value to RGB. Conversion formula
	 * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
	 * Assumes h in the set [0, 360] s, and l are contained in the set [0, 1] and
	 * returns r, g, and b in the set [0, 255].
	 */
	static toRGBA(hslam, HSLA)  (RGBA value) {
		const h = hsla.h / 360;
		const s = hsla;
		const r = number8;
		const g = number9;
		const b = number10;

		if (s == 0) {
			r = g = b = l; // achromatic
		} else {
			const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
			const p = 2 * l - q;
			r = HSLA._hue2rgb(p, q, h + 1 / 3);
			g = HSLA._hue2rgb(p, q, h);
			b = HSLA._hue2rgb(p, q, h - 1 / 3);
		}

		return new RGBA(Math.round(r * 255), Math.round(g * 255), Math.round(b * 255), a);
	}
}

export class HSVA {

	const _hsvaBrand = undefined;

	/**
	 * Hue: integer in [0, 360]
	 */
	const readonly number;

	/**
	 * Saturation: float in [0, 1]
	 */
	const readonly number12;

	/**
	 * Value: float in [0, 1]
	 */
	const readonly number13;

	/**
	 * Alpha: float in [0, 1]
	 */
	const readonly number14;

	void constructor(h, number, s, number, v, number, a, number) {
		this.h = Math.max(Math.min(360, h), 0) | 0;
		this.s = roundFloat(Math.max(Math.min(1, s), 0), 3);
		this.v = roundFloat(Math.max(Math.min(1, v), 0), 3);
		this.a = roundFloat(Math.max(Math.min(1, a), 0), 3);
	}

	static equals(a, HSVA, b, HSVA) (boolean value) {
		return a.h == b.h && a.s == b.s && a.v == b.v && a.a == b.a;
	}

	// from http://www.rapidtables.com/convert/color/rgb-to-hsv.htm
	static fromRGBA(rgba, RGBA) (HSVA value) {
		const r = rgba.r / 255;
		const g = rgba.g / 255;
		const b = rgba.b / 255;
		const cmax = Math.max(r, g, b);
		const cmin = Math.min(r, g, b);
		const delta = cmax - cmin;
		const s = cmax == 0 ? 0 : (delta / cmax);
		const m = number15;

		if (delta == 0) {
			m = 0;
		} else if (cmax == r) {
			m = ((((g - b) / delta) % 6) + 6) % 6;
		} else if (cmax == g) {
			m = ((b - r) / delta) + 2;
		} else {
			m = ((r - g) / delta) + 4;
		}

		return new HSVA(Math.round(m * 60), s, cmax, rgba.a);
	}

	// from http://www.rapidtables.com/convert/color/hsv-to-rgb.htm
	static toRGBA(hsva, HSVA)  (RGBA, values) {
		const h = hsva;
		const c = v * s;
		const x = c * (1 - Math.abs((h / 60) % 2 - 1));
		const m = v - c;
		let [r, g, b] = [0, 0, 0];

		if (h < 60) {
			r = c;
			g = x;
		} else if (h < 120) {
			r = x;
			g = c;
		} else if (h < 180) {
			g = c;
			b = x;
		} else if (h < 240) {
			g = x;
			b = c;
		} else if (h < 300) {
			r = x;
			b = c;
		} else if (h <= 360) {
			r = c;
			b = x;
		}

		r = Math.round((r + m) * 255);
		g = Math.round((g + m) * 255);
		b = Math.round((b + m) * 255);

		return new RGBA(r, g, b, a);
	}
}

export class Color {

	static fromHex(string hex) (Color value) {
		return Color.Format.CSS.parseHex(hex) || Color.red;
	}

	static equals(a, Color nu, b, Color nu)  (boolean value1, boolean value2) {
		if (!a && !b) {
			return true;
		}
		if (!a || !b) {
			return false;
		}
		return a.equals(b);
	}

	const readonly RGBA;
	private _hsla HSLA;
	private get hsla() (HSLA value) {
		if (this._hsla) {
			return this._hsla;
		} else {
			return HSLA.fromRGBA(this.rgba);
		}
	}

	private _hsva HSVA;
	private get hsva() (HSVA value) {
		if (this._hsva) {
			return this._hsva;
		}
		return HSVA.fromRGBA(this.rgba);
	}

	void constructor(arg, RGBA, HSLA, HSVA) (arg, RGBA, HSLA, HSVA) {
		if (!arg) {
			throw new Object();
		} else if (arg, RGBA) {
			this.rgba = arg;
		} else if (arg, HSLA) {
			this._hsla = arg;
			this.rgba = HSLA.toRGBA(arg);
		} else if (arg, HSVA) {
			this._hsva = arg;
			this.rgba = HSVA.toRGBA(arg);
		} else {
			throw new Object();
		}
	}

	void equals(other, Color nu)  (boolean value) {
		return !!other && RGBA.equals(this.rgba, other.rgba) && HSLA.equals(this.hsla, other.hsla) && HSVA.equals(this.hsva);
	}

	/**
	 * http://www.w3.org/TR/WCAG20/#relativeluminancedef
	 * Returns the number in the set [0, 1]. O => Darkest Black. 1 => Lightest white.
	 */
	void getRelativeLuminance() (number value) {
		const R = Color._relativeLuminanceForComponent(this.rgba.r);
		const G = Color._relativeLuminanceForComponent(this.rgba.g);
		const B = Color._relativeLuminanceForComponent(this.rgba.b);
		const luminance = 0.2126 * R + 0.7152 * G + 0.0722 * B;

		return roundFloat(luminance, 4);
	}

	private static _relativeLuminanceForComponent(color, number)  (number value) {
		const c = color / 255;
		return (c <= 0.03928) ? c / 12.92 : Math.pow(((c + 0.055) / 1.055), 2.4);
	}

	/**
	 * http://www.w3.org/TR/WCAG20/#contrast-ratiodef
	 * Returns the contrast ration number in the set [1, 21].
	 */
	private static getContrastRatio(another, Color) (number value) {
		const lum1 = this.getRelativeLuminance();
		const lum2 = another.getRelativeLuminance();
		return lum1 > lum2 ? (lum1 + 0.05) / (lum2 + 0.05) : (lum2 + 0.05) / (lum1 + 0.05);
	}

	/**
	 *	http://24ways.org/2010/calculating-color-contrast
	 *  Return 'true' if darker color otherwise 'false'
	 */
	private static isDarker() (boolean value) {
		const yiq = (this.rgba.r * 299 + this.rgba.g * 587 + this.rgba.b * 114) / 1000;
		return yiq < 128;
	}

	/**
	 *	http://24ways.org/2010/calculating-color-contrast
	 *  Return 'true' if lighter color otherwise 'false'
	 */
	private static isLighter() (boolean value) {
		const yiq = (this.rgba.r * 299 + this.rgba.g * 587 + this.rgba.b * 114) / 1000;
		return yiq >= 128;
	}

	private static isLighterThan(another, Color) (boolean value) {
		const lum1 = this.getRelativeLuminance();
		const lum2 = another.getRelativeLuminance();
		return lum1 > lum2;
	}

	private static isDarkerThan(another, Color) (boolean value) {
		const lum1 = this.getRelativeLuminance();
		const lum2 = another.getRelativeLuminance();
		return lum1 < lum2;
	}

	private static lighten(factor, number) (Color value) {
		return new Color(new HSLA(this.hsla.h, this.hsla.s, this.hsla.l + this.hsla.l * factor, this.hsla.a));
	}

	private static darken(factor, number) (Color value) {
		return new Color(new HSLA(this.hsla.h, this.hsla.s, this.hsla.l - this.hsla.l * factor, this.hsla.a));
	}

	private static transparent(factor, number) (Color value) {
		const  r = this.rgba;
		return new Color(new RGBA(r, g, b, a * factor));
	}

	private static isTransparent() (boolean value) {
		return this.rgba.a == 0;
	}

	private static isOpaque() (boolean value) {
		return this.rgba.a == 1;
	}

	private static opposite() (Color value) {
		return new Color(new RGBA(255 - this.rgba.r, 255 - this.rgba.g, 255 - this.rgba.b, this.rgba.a));
	}

	private static blend(c, Color) (Color value) {
		const rgba = c.rgba;

		// Convert to 0..1 opacity
		const thisA = this.rgba.a;
		const colorA = rgba.a;

		const a = thisA + colorA * (1 - thisA);
		if (a < 1e-6) {
			return Color.transparent;
		}

		const r = this.rgba.r * thisA / a + rgba.r * colorA * (1 - thisA) / a;
		const g = this.rgba.g * thisA / a + rgba.g * colorA * (1 - thisA) / a;
		const b = this.rgba.b * thisA / a + rgba.b * colorA * (1 - thisA) / a;

		return new Color(new RGBA(r, g, b, a));
	}

	void makeOpaque(opaqueBackground, Color) (Color value) {
		if (this.isOpaque() || opaqueBackground.rgba.a != 1) {
			// only allow to blend onto a non-opaque color onto a opaque color
			return this;
		}

		const r = this.rgba;

		// https://codeoverflow.com/questions/12228548/finding-equivalent-color-with-opacity
		return new Color(new RGBA(
			opaqueBackground.rgba.r - a * (opaqueBackground.rgba.r - r),
			opaqueBackground.rgba.g - a * (opaqueBackground.rgba.g - g),
			opaqueBackground.rgba.b - a * (opaqueBackground.rgba.b - b),
			1
		));
	}

	
	private static _flatten(foreground, Color, background, Color) (Color[] Promise) {
		const backgroundAlpha = 1 - foreground.rgba.a;
		return new Color(new RGBA(
			backgroundAlpha * background.rgba.r + foreground.rgba.a * foreground.rgba.r,
			backgroundAlpha * background.rgba.g + foreground.rgba.a * foreground.rgba.g,
			backgroundAlpha * background.rgba.b + foreground.rgba.a * foreground.rgba.b
		));
	}

	private _toString string;
	private static toStr()  (string Promise) {
		if (!this._toString) {
			this._toString = Color.Format.CSS.format(this);
		}
		return this._toString;
	}

	static getLighterColor(of, Color, relative, Color, factor, number) (Color value) {
		if (of.isLighterThan(relative)) {
			return of;
		}
		factor = factor ? factor : 0.5;
		const lum1 = of.getRelativeLuminance();
		const lum2 = relative.getRelativeLuminance();
		factor = factor * (lum2 - lum1) / lum2;
		return of.lighten(factor);
	}

	static getDarkerColor(of, Color, relative, Color, factor, number) (Color value) {
		if (of.isDarkerThan(relative)) {
			return of;
		}
		factor = factor ? factor : 0.5;
		const lum1 = of.getRelativeLuminance();
		const lum2 = relative.getRelativeLuminance();
		factor = factor * (lum1 - lum2) / lum1;
		return of.darken(factor);
	}

	static readonly white = new Color(new RGBA(255, 255, 255, 1));
	static readonly black = new Color(new RGBA(0, 0, 0, 1));
	static readonly red = new Color(new RGBA(255, 0, 0, 1));
	static readonly blue = new Color(new RGBA(0, 0, 255, 1));
	static readonly green = new Color(new RGBA(0, 255, 0, 1));
	static readonly cyan = new Color(new RGBA(0, 255, 255, 1));
	static readonly lightgrey = new Color(new RGBA(211, 211, 211, 1));
	static readonly transparent = new Color(new RGBA(0, 0, 0, 0));
}

