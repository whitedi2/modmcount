﻿Процедура ЗапуститьНачальныеПроцедурыЧата(ПользователиЧат, ПредметОбсуждения, СтрокаИстории, ИсторияЧатHTML, Элементы) Экспорт
	ОбновитьЧатПервыйЗапуск(ПользователиЧат, ПредметОбсуждения, СтрокаИстории, ИсторияЧатHTML, Элементы);
	сабВнутреннийЧатСервер.ПрочитатьНовые(Неопределено,,Истина);

	
КонецПроцедуры

Процедура ОбновитьЧатПервыйЗапуск(ПользователиЧат, ПредметОбсуждения, СтрокаИстории, ИсторияЧатHTML, Элементы)
	ЗвуковойСигнал = Ложь;
	СписокПользователей = Новый СписокЗначений;
	СписокНепрочтенных = Новый СписокЗначений;
	СписокЗначениеИнциденты = Новый СписокЗначений;
	СписокМоихИнцидентов = Новый СписокЗначений;
	СписокИБ = Новый СписокЗначений;
	СписокОбращенияВТП = Новый СписокЗначений;
	СкриптЗапускался = Ложь;
	Если НЕ Элементы.ПользователиЧат.ТекущиеДанные = Неопределено Тогда
		ТекПользователь = Элементы.ПользователиЧат.ТекущиеДанные.Ссылка;
		ТекИБ = Элементы.ПользователиЧат.ТекущиеДанные.ИБ;
	Иначе
		ТекПользователь = Неопределено;	
		ТекИБ = Неопределено;
	КонецЕсли;
	
	сабВнутреннийЧатСервер.ЗаполнитьЧатHTML(ИсторияЧатHTML,, ЗвуковойСигнал, СписокПользователей, СписокНепрочтенных, СписокЗначениеИнциденты,СписокМоихИнцидентов, СписокИБ, СписокОбращенияВТП, ТекПользователь, ТекИБ, Ложь, Истина, СтрокаИстории, ПредметОбсуждения);
	Если ЗвуковойСигнал Тогда
		ПоказатьВсплывающееОкно();
		//БюджетныйНаКлиенте.ВоспроизвестиЗвук("УведомлениеЧат");
		сабВнутреннийЧатСервер.ПрочитатьНовые(, Истина, Истина);
	КонецЕсли;
	
	ЗаполнитьСписокПользователейЧата(СписокПользователей, СписокНепрочтенных, СписокЗначениеИнциденты, СписокМоихИнцидентов, СписокИБ, СписокОбращенияВТП, ПользователиЧат);
КонецПроцедуры

Процедура ЗаполнитьСписокПользователейЧата(СписокПользователей, СписокНепрочтенных, СписокЗначениеИнциденты, СписокМоихИнцидентов, СписокИБ, СписокОбращенияВТП, ПользователиЧат) Экспорт
	Для каждого ТекПользователь Из СписокПользователей Цикл
		ОтобраннаяСтрока = ПользователиЧат.НайтиСтроки(Новый Структура("Ссылка, ИБ", ТекПользователь.Значение, СписокИБ[СписокПользователей.Индекс(ТекПользователь)].Значение));
		Если НЕ ОтобраннаяСтрока.Количество()  Тогда
			НоваяСтрока = ПользователиЧат.Вставить(0);
			НоваяСтрока.Ссылка = ТекПользователь.Значение;
		Иначе
			НоваяСтрока = ОтобраннаяСтрока[0];
		КонецЕсли;
		НоваяСтрока.Колич = СписокНепрочтенных[СписокПользователей.Индекс(ТекПользователь)].Значение;
		НоваяСтрока.ИнцидентЗакрыт = СписокЗначениеИнциденты[СписокПользователей.Индекс(ТекПользователь)].Значение;
		НоваяСтрока.МойИнцидент = СписокМоихИнцидентов[СписокПользователей.Индекс(ТекПользователь)].Значение;
		НоваяСтрока.ИБ = СписокИБ[СписокПользователей.Индекс(ТекПользователь)].Значение;
		НоваяСтрока.ОбращениеВТП= СписокОбращенияВТП[СписокПользователей.Индекс(ТекПользователь)].Значение;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОтправитьВЧат(Команда, СкриптЗапускался, ЭтаФорма, СообщениеТекст, ПредметОбсуждения, ИсторияЧатHTML, Элементы) Экспорт
	СкриптЗапускался = Ложь;
	СообщениеСодержимое = СообщениеТекст.ПолучитьТекст();
	Если НЕ ПустаяСтрока(СообщениеСодержимое) Тогда
		ЭтоАдмин = БюджетныйНаСервере.РольАдминаДоступнаСервер();
		//Если ЭтоАдмин Тогда
		Если НЕ Элементы.ПользователиЧат.ТекущиеДанные = Неопределено Тогда
			ТекПользовательЧата = Элементы.ПользователиЧат.ТекущиеДанные.Ссылка;
			ТекИБ = Элементы.ПользователиЧат.ТекущиеДанные.ИБ; 
			//Иначе
			//	Сообщение = Новый СообщениеПользователю;
			//	Сообщение.Текст = "Не указан пользователь!";
			//	Сообщение.Поле = "ПользователиЧат";
			//	Сообщение.Сообщить();
			//	Возврат;		
			//Иначе
			//	ТекИБ = сабОбщегоНазначения.ПолучитьТекущуюИБ();
			//КонецЕсли;
			ИдентификаторСообщения = Новый УникальныйИдентификатор;
			//ТекПользователь = ?(ЭтоАдмин, ТекПользовательЧата, Неопределено);
			сабВнутреннийЧатСервер.СоздатьНовоеСообщениеЧата(ТекПользовательЧата, СообщениеСодержимое, Не ЗначениеЗаполнено(ПредметОбсуждения) И Элементы.ПользователиЧат.ТекущиеДанные.ОбращениеВТП, ЭтоАдмин, , , ТекИБ, ИдентификаторСообщения, ПредметОбсуждения);
			//сабВнутреннийЧатСервер.ЗаполнитьЧатHTML(ИсторияЧатHTML,,Ложь,,,,,,,,,,"", ПредметОбсуждения);
			СообщениеТекст = Неопределено;
			//Элементы.Соощение.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.ПриИзмененииЗначения;
			//Элементы.Соощение.ОбновитьТекстРедактирования();
			//Элементы.Сообщение.АктивизироватьПоУмолчанию = Истина;
			
			//отправим сообщение в другие ИБ через веб сервис
			сабВнутреннийЧатСервер.ОтправитьВДругиеИБ(ТекПользовательЧата, СообщениеСодержимое, Истина, ЭтоАдмин, ТекИБ, ИдентификаторСообщения);
		КонецЕсли;
		
	Иначе
		//Сообщение1 = Новый СообщениеПользователю;
		//Сообщение1.Текст = "Не заполнено сообщение";
		//Сообщение1.Поле = "Сообщение";
		//Сообщение1.Сообщить(); 
	КонецЕсли;
	ЭтаФорма.ТекущийЭлемент = Элементы.Сообщение;
	Сообщение = "";
КонецПроцедуры

Процедура ПоказатьВсплывающееОкно() Экспорт
	
	ТекЗапись = сабВнутреннийЧатСервер.ПолучитьПоследнююЗапись();
	Если НЕ ТекЗапись = Неопределено Тогда
		#Если МобильныйКлиент Или МобильноеПриложениеКлиент Тогда
			Сообщить(Строка(ТекЗапись.Автор) + ":
			|" + Формат(ТекЗапись.ДатаВремя, "ДЛФ=T") + "
			|" + ТекЗапись.Текст, СтатусСообщения.Важное);
		#Иначе
			ПоказатьОповещениеПользователя("Сообщение чата 1С",,Строка(ТекЗапись.Автор) + ":
			|" + Формат(ТекЗапись.ДатаВремя, "ДЛФ=T") + "
			|" + ТекЗапись.Текст, БиблиотекаКартинок.Документ,СтатусОповещенияПользователя.Информация,Новый УникальныйИдентификатор);
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

