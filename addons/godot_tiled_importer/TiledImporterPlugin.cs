#if TOOLS
using Godot;
using System;

[Tool]
public partial class TiledImporterPlugin : EditorPlugin
{
    EditorImportPlugin mapFormatImportPlugin = null;

    public override string _GetPluginName() => "Godot Tiled Importer";

    public override void _EnterTree()
    {
        mapFormatImportPlugin = new EditorTiledMapFormatImportPlugin();
        AddImportPlugin(mapFormatImportPlugin);
    }

    public override void _ExitTree()
    {
        RemoveImportPlugin(mapFormatImportPlugin);
    }
}
#endif
