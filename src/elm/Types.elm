module Types exposing (..)

import Editor
import EveryDict exposing (EveryDict)
import EverySet exposing (EverySet)
import Html exposing (Html)
import Json.Encode as JE


type Msg
    = MsgForElm MsgForElm
    | LogError String
      -- user actions
    | CreateNewProject
      -- selection
    | SelectPackage PackageId
    | SelectModule ModuleId
    | SelectDefinition DefinitionId
      -- deselection
    | DeselectPackage
    | DeselectModule
    | DeselectDefinition
      -- other
    | SetFilter FilterType Bool
      -- app actions
    | ShowFooterMsg ( Html Msg, String )
    | HideFooterMsg
      -- components
    | EditorMsg Editor.Msg


type MsgForElectron
    = ErrorLogRequested String
    | ChangeTitle String


type MsgForElm
    = ProjectClosed


type alias Model =
    { project : Maybe Project
    , footerMsg : Maybe ( Html Msg, String )
    , editor : Editor.Model
    }


type alias Project =
    { rootPath : String
    , index : Maybe Index
    , selection : Selection
    , filterConfig : FilterConfig
    }


type alias FilterConfig =
    { packages : PackagesFilterConfig
    , modules : ModulesFilterConfig
    , definitions : DefinitionsFilterConfig
    }


type FilterType
    = -- packages
      UserPackages
    | DirectDeps
    | DepsOfDeps
      -- modules
    | ExposedModules
    | EffectModules
    | NativeModules
    | PortModules
      -- definitions
    | ExposedDefinitions


type alias PackagesFilterConfig =
    -- TODO maybe effect and native-containing packages? "dangerous?"
    { user : Bool
    , directDeps : Bool
    , depsOfDeps : Bool
    }


type alias ModulesFilterConfig =
    { exposed : Bool
    , effect : Bool
    , native : Bool
    , port_ : Bool
    }


type alias DefinitionsFilterConfig =
    { exposed : Bool
    }


type Selection
    = NothingSelected
    | PackageSelected PackageId
    | ModuleSelected ModuleId
    | PackageAndModuleSelected PackageId ModuleId
    | ModuleAndDefinitionSelected ModuleId DefinitionId
    | AllSelected PackageId ModuleId DefinitionId


type alias Index =
    { packages : EveryDict PackageId Package
    , modules : EveryDict ModuleId Module
    , definitions : EveryDict DefinitionId Definition
    }


type alias Package =
    { name : String
    , version : Maybe String
    , dependencyType : DependencyType
    , containsEffectModules : Bool
    , containsNativeModules : Bool
    , modules : EverySet ModuleId
    }


type alias Module =
    { name : String
    , isExposed : Bool
    , isEffect : Bool
    , isNative : Bool
    , isPort : Bool
    , definitions : EverySet DefinitionId
    , language : Language
    }


type alias Definition =
    { name : String
    , kind : DefinitionKind
    , isExposed : Bool
    , sourceCode : SourceCode
    }


type SourceCode
    = SourceCode String


type alias Named a =
    { a | name : String }


type alias Authored a =
    { a | author : String }


type alias CommonDefinition a =
    Named { a | isExposed : Bool }


type DependencyType
    = UserPackage
    | DirectDependency
    | DependencyOfDependency


type Language
    = Elm
    | JavaScript


type PackageId
    = PackageId String


type ModuleId
    = ModuleId String


type DefinitionId
    = DefinitionId String


type DefinitionKind
    = Constant { type_ : String }
    | Function { type_ : String }
    | Type
    | TypeConstructor { type_ : String }
    | TypeAlias


type alias PortData =
    { tag : String
    , data : JE.Value
    }



-- TODO fixities somewhere?
