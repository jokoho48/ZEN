#include "script_component.hpp"
/*
 * Author: mharis001
 * Adds custom compositions to the empty compositions tree.
 * Handles any currently active search which hides needed tree paths.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [DISPLAY] call zen_compositions_fnc_processTreeAdditions
 *
 * Public: No
 */

// Fast exit for common case when nothing is waiting to be added
if (GVAR(treeAdditions) isEqualTo []) exitWith {};

params ["_display"];

private _ctrlTree = _display displayCtrl IDC_RSCDISPLAYCURATOR_CREATE_GROUPS_EMPTY;
private _delete = false;

private _categories = _ctrlTree getVariable QGVAR(categories);

if (isNil "_categories") then {
    _categories = [];
    _ctrlTree setVariable [QGVAR(categories), _categories];
};

for "_i" from 0 to ((_ctrlTree tvCount [0]) - 1) do {
    if (_ctrlTree tvData [0, _i] == CATEGORY_STR) exitWith {
        {
            _x params ["_category", "_name", "_data"];

            private "_path";

            if (_category in _categories) then {
                // Try to find previously added category's current path in the tree
                for "_j" from 0 to ((_ctrlTree tvCount [0, _i]) - 1) do {
                    if (_ctrlTree tvText [0, _i, _j] == _category) exitWith {
                        _path = [0, _i, _j];
                    };
                };
            } else {
                // Add category to tree since it has not been added yet
                _categories pushBack _category;
                _path = [0, _i, _ctrlTree tvAdd [[0, _i], _category]];
                _ctrlTree tvSetData [_path, SUBCATEGORY_STR];
            };

            // Add the composition to the tree if a path for the category currently exists
            if (!isNil "_path") then {
                _path pushBack (_ctrlTree tvAdd [_path, _name]);

                _ctrlTree tvSetTooltip [_path, _name];
                _ctrlTree tvSetData [_path, COMPOSITION_STR];
                _ctrlTree tvSort [GET_PARENT_PATH(_path), false];

                _ctrlTree setVariable [FORMAT_OBJECT_DATA_VAR(_category,_name), _data];

                GVAR(treeAdditions) set [_forEachIndex, []];
                _delete = true;
            };
        } forEach GVAR(treeAdditions);

        // Sort categories at the end to prevent issues with changing indices
        _ctrlTree tvSort [[0, _i], false];
    };
};

if (_delete) then {
    GVAR(treeAdditions) = GVAR(treeAdditions) - [[]];
};
