using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.Intrinsics.X86;
using System.Threading.Tasks;

namespace ChessAP.chess.fairybot.Framework
{
    public interface Evaluater
    {
        int evaluate(Board board);
    }
}