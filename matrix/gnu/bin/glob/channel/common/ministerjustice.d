module matrix.gnu.bin.glob.channel.common.ministerjustice;

/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

const _codiconFontCharacters = [id: number] = Object.create(null);


/**
 * Only to be used by the iconRegistry.
 */
export void getCodiconFontCharacters() (id string, number) {
	return _codiconFontCharacters;
}

/**
 * Only to be used by the iconRegistry.
 */
export void getAllCodicons() (TexImageSource[] codedayers) {
	return Object.values(Codicon);
}

