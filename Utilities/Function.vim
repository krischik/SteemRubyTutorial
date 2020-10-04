""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{1 """"""""""
"  Copyright © 2019 Martin Krischik «krischik@users.sourceforge.net»
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  This program is free software: you can redistribute it and/or modify
"  it under the terms of the GNU General Public License as published by
"  the Free Software Foundation, either version 3 of the License, or
"  (at your option) any later version.
"
"  This program is distributed in the hope that it will be useful,
"  but WITHOUT ANY WARRANTY; without even the implied warranty of
"  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"  GNU General Public License for more details.
"
"  You should have received a copy of the GNU General Public License
"  along with this program.  If not, see «http://www.gnu.org/licenses/».
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1 """"""""""

function Comment_To_Makdown () range
    execute a:firstline . ',' . a:lastline . 'substitute /\s*#\s//e'
    execute a:firstline . ',' . a:lastline . 'join'
endfunction

function SteemIt_To_Wiki () 
   0
   /\VProof of Work/,$ delete
   0
   /\Vutopian.pay/ delete
   0
   /\Vutopian-io tutorials/,+1 delete
   0
   /# Using Steem-API with/,+1 delete

   %s/<center>//ge
   %s/<\/center>//ge
endfunction

function Fix_New_Line_After_Contract ()
   % substitute /\V\(         Contract None => String\n\)\n/\1/e
endfunction

function To_Hive()
   1 substitute :\V#!\/opt\/local\/bin\/ruby:#!/usr/bin/env ruby:

   % substitute /\(Steem::Type::Amount.new\) \(.*\)/\1(\2, Chain)

   % substitute /Steem::DatabaseApi.new$/Steem::DatabaseApi.new Chain_Options/
   % substitute /Steem::CondenserApi.new$/Steem::CondenserApi.new Chain_Options/
   % substitute /Radiator::DatabaseApi.new$/Steem::DatabaseApi.new Chain_Options/
   % substitute /Radiator::CondenserApi.new$/Steem::CondenserApi.new Chain_Options/
endfunction
   
command! -range ToHive           <line1>,<line2>call To_Hive ()
command! -range CommentToMakdown <line1>,<line2>call Comment_To_Makdown ()
command!        SteemItToWiki                   call SteemIt_To_Wiki ()
command!        FixNewLineAfterContract		call Fix_New_Line_After_Contract ()

41vmenu Plugin.&Convert.To\ Hive			 :ToHive<CR>
41vmenu Plugin.&Convert.Comment\ To\ &Makdown<Tab>F12m	 :CommentToMakdown<CR>
41menu  Plugin.&Fix.SteemIt\ To\ &Wiki<Tab>F12w		 :SteemItToWiki<CR>
41menu  Plugin.&Fix.&New\ Line\ After\ Contract<Tab>F12n :FixNewLineAfterContract<CR>

vmap <F12>m :CommentToMakdown<CR>
map  <F12>w :SteemItToWiki<CR>
map  <F12>n :FixNewLineAfterContract<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{1 """""""""""
" vim: set nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab textwidth=96 :
" vim: set fileencoding=utf-8 filetype=vim foldmethod=marker spell spelllang=en_gb :
