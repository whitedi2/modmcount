﻿Процедура ОтправитьВДругиеИБ(Кому, Текст, СообщениеТехподдержки, ЭтоАдмин, ТекИБ, ИдентификаторСообщения) Экспорт
	
	//Если Не Константы.ТекущаяИБ.Получить().ПолучатьСообщенияГорячейЛинии Или Константы.БазаТехподдержки.Получить() Тогда
		Возврат;
	//КонецЕсли;	
	
	ТекДата = ТекущаяДата();
	
	Если Кому = Неопределено Тогда
		Кому = Справочники.Пользователи.Администратор; //в случае обращения в ТП	
	КонецЕсли;
	
	Попытка
		ПроксиСервер = WSСсылки.ObmenSupp.СоздатьWSПрокси("ObmenSupp", "ObmenSupp", "ObmenSuppSoap");
		ПроксиСервер.Пользователь = "Администратор";
		ПроксиСервер.Пароль = "qwe3221";
		
		ПроксиСервер.Exchange("OUT", Кому.Наименование, Текст, ТекИБ.Наименование, Строка(ИдентификаторСообщения), ПараметрыСеанса.ТекущийПользователь.Наименование, 0, "", Ложь, Ложь, СообщениеТехподдержки, ЭтоАдмин, ТекДата);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьПоследнююЗапись() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Ч_СообщенияЧата.ИдентификаторСообщения,
	               |	Ч_СообщенияЧата.Автор,
	               |	ЕСТЬNULL(сабЧат_ОповещенияЧата.Кому, Ч_СообщенияЧата.Кому) КАК Кому,
	               |	Ч_СообщенияЧата.ДатаВремя,
	               |	Ч_СообщенияЧата.НомерСообщения,
	               |	Ч_СообщенияЧата.Оформление,
	               |	Ч_СообщенияЧата.Текст,
	               |	ЕСТЬNULL(сабЧат_ОповещенияЧата.Прочитано, ИСТИНА) КАК Прочитано,
	               |	ЕСТЬNULL(сабЧат_ОповещенияЧата.Показано, ИСТИНА) КАК Показано,
	               |	Ч_СообщенияЧата.СообщениеТехподдержки,
	               |	Ч_СообщенияЧата.АвторАдмин,
	               |	Ч_СообщенияЧата.ИДИнцидента,
	               |	Ч_СообщенияЧата.ОписаниеИнцидента,
	               |	Ч_СообщенияЧата.ОбъектМетаданных,
	               |	Ч_СообщенияЧата.Ответственный,
	               |	Ч_СообщенияЧата.ИнцидентЗакрыт,
	               |	Ч_СообщенияЧата.Файл,
	               |	Ч_СообщенияЧата.БазаОбращения,
	               |	Ч_СообщенияЧата.НеобходимОбмен,
	               |	Ч_СообщенияЧата.Документ
	               |ИЗ
	               |	РегистрСведений.Ч_СообщенияЧата КАК Ч_СообщенияЧата
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.сабЧат_ОповещенияЧата КАК сабЧат_ОповещенияЧата
	               |		ПО Ч_СообщенияЧата.ИдентификаторСообщения = сабЧат_ОповещенияЧата.ИдентификаторСообщения
	               |			И (сабЧат_ОповещенияЧата.Кому В (&Кому))
	               |			И (сабЧат_ОповещенияЧата.Прочитано = ЛОЖЬ)";
	
	
	МассивПользователей = Новый Массив;
	МассивПользователей.Добавить(ПараметрыСеанса.ТекущийПользователь);
	Если БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		МассивПользователей.Добавить(сабОбщегоНазначенияПовтИсп.ПолучиьПользователяАдминистратор());
		МассивПользователей.Добавить(сабОбщегоНазначенияПовтИсп.ПолучиьГруппуТехподдержки());
	КонецЕсли;
	Запрос.УстановитьПараметр("Кому", МассивПользователей);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ПоказыватьПоОдному = Истина;
	Пока Выборка.Следующий() Цикл
		Если НЕ Выборка.Показано И ПоказыватьПоОдному = Истина Тогда
			НоваяЗапись = РегистрыСведений.Ч_СообщенияЧата.СоздатьМенеджерЗаписи();
			НоваяЗапись.ИдентификаторСообщения = Выборка.ИдентификаторСообщения;
			НоваяЗапись.Автор = Выборка.Автор;
			НоваяЗапись.Кому = Выборка.Кому;
			НоваяЗапись.Прочитать();
			Если НоваяЗапись.Выбран() Тогда
				НоваяЗапись.Показано = Истина;	
				НоваяЗапись.Записать();
			КонецЕсли;
			
			//д1. 04.05.16 расширенное прочтение
			НоваяЗапись = РегистрыСведений.сабЧат_ОповещенияЧата.СоздатьМенеджерЗаписи();
			НоваяЗапись.ИдентификаторСообщения = Выборка.ИдентификаторСообщения;
			НоваяЗапись.Кому = Выборка.Кому;
			НоваяЗапись.Прочитать();
			Если НоваяЗапись.Выбран() Тогда
				НоваяЗапись.Показано = Истина;	
				НоваяЗапись.Записать();
			КонецЕсли;
			//д1. 04.05.16 конец
			
			ПоказыватьПоОдному = Ложь;
			Возврат Новый Структура("Текст, Автор, ДатаВремя, ИдентификаторСообщения, СообщениеТехподдержки", Выборка.Текст, Выборка.Автор, Выборка.ДатаВремя, Выборка.ИдентификаторСообщения, Выборка.СообщениеТехподдержки);
		КонецЕсли;
	КонецЦикла;
	
КонецФункции // ()

Процедура ЗаполнитьЧатHTML(НовостиHTML, НомерСтраницы = "", ЗвуковойСигнал, СписокПользователей = Неопределено,
	СписокНепрочтенных = Неопределено, СписокЗначениеИнциденты = Неопределено, СписокМоихИнцидентов = Неопределено,
	СписокИБ = Неопределено, СписокОбращенияВТП = Неопределено, Текпользователь = Неопределено, ТекИБ = Неопределено, ТекПользовательПишетВТП = Неопределено,
	ПервыйЗапуск = Ложь, СтрокаИстории, ПредметОбсуждения, ИсторияЧата = Ложь) Экспорт
	
	ИсторияЧатHTML = "";
	ЗвуковойСигнал = Ложь;
	ЭтоАдмин = БюджетныйНаСервере.РольАдминаДоступнаСервер();
	ТекущийПользовательСеанса = ПараметрыСеанса.ТекущийПользователь;
	
	//ограничиваем дату в запросе
	Если НомерСтраницы = "Вчера" Тогда
		ДатаВремя1 = НачалоДня(ТекущаяДата() - 24*60*60);
		ДатаВремя2 = КонецДня(ТекущаяДата());
		ИсторияЧата = Ложь;
	ИначеЕсли НомерСтраницы = "7 дней" Тогда
		ДатаВремя1 = НачалоДня(ТекущаяДата() - 7*24*60*60);
		ДатаВремя2 = КонецДня(ТекущаяДата());
		ИсторияЧата = Ложь
	ИначеЕсли НомерСтраницы = "30 дней" Тогда
		ДатаВремя1 = НачалоДня(ТекущаяДата() - 30*24*60*60);
		ДатаВремя2 = КонецДня(ТекущаяДата());
		ИсторияЧата = Ложь;
	//ИначеЕсли НомерСтраницы = "Все" ИЛИ ПервыйЗапуск Тогда
	ИначеЕсли ПервыйЗапуск Тогда
		ДатаВремя1 = Дата('00010101');
		ДатаВремя2 = КонецДня(ТекущаяДата());
		ИсторияЧата = Ложь;
	ИначеЕсли НомерСтраницы = "История" и Не ИсторияЧата Тогда  //обход повторного запроса всей истории чата
		ДатаВремя1 = Дата('00010101');
		ДатаВремя2 = КонецДня(ТекущаяДата());
		ИсторияЧата = Истина;
		
	ИначеЕсли НомерСтраницы = "История" и ИсторияЧата Тогда     //отмена обхода повторного запроса всей истории чата(оптимизация)
		Возврат;
	Иначе
		ДатаВремя1 = НачалоДня(ТекущаяДата());
		ДатаВремя2 = КонецДня(ТекущаяДата());
		ИсторияЧата = Ложь;
	КонецЕсли;
	
	//{Собираем сообщения из других баз
	//Если Константы.ТекущаяИБ.Получить().ПолучатьСообщенияГорячейЛинии И Не Константы.БазаТехподдержки.Получить() Тогда
	//	//СтрокиСоответствия = ТаблицаПоБазам.НайтиСтроки(Новый Структура("База, Соответствие, ТипОбъекта", СтрокаБаз.База, ТекущийПользовательСеанса, "Справочник.Пользователи"));
	//	//Если СтрокиСоответствия.Количество() = 0 Тогда
	//		ТекущийПользовательСеансаВДБ = ТекущийПользовательСеанса.Наименование;
	//		//Сообщить("Не указано соответствие текущего пользователя с базой " + СтрокаБаз.База);
	//		//Продолжить;
	//	//Иначе
	//	//	ТекущийПользовательСеансаВДБ = СтрокиСоответствия[0].Значение77;
	//	//КонецЕсли;	
	//	
	//	Попытка
	//		ПроксиСервер = WSСсылки.ObmenSupp.СоздатьWSПрокси("ObmenSupp", "ObmenSupp", "ObmenSuppSoap");
	//		ПроксиСервер.Пользователь = "Администратор";
	//		ПроксиСервер.Пароль = "qwe3221";
	//		
	//		ДанныеВДБУпак = ПроксиСервер.Exchange("IN", "", "", сабОбщегоНазначения.ПолучитьТекущуюИБ().Наименование, "", "", 0, "", ложь, ложь, истина, истина, Дата("00010101"));
	//		
	//		ДанныеВДБ = БПСервер.РаспаковатьТекстXML(ДанныеВДБУпак);
	//		
	//		Для Каждого ВыборкаВДБ Из ДанныеВДБ Цикл
	//			ТекАвтор = Справочники.Пользователи.НайтиПоНаименованию(ВыборкаВДБ.Автор, Истина);
	//			//Если Не ЗначениеЗаполнено(ТекАвтор) Тогда
	//			//	СтрокиСоответствия = ТаблицаПоБазам.НайтиСтроки(Новый Структура("База, Значение77, ТипОбъекта", СтрокаБаз.База, ВыборкаВДБ.Автор, "Справочник.Пользователи"));
	//			//	Если СтрокиСоответствия.Количество() = 0 Тогда
	//			//		Сообщить("Не указано соответствие пользователя " + ВыборкаВДБ.Автор + " с базой " + СтрокаБаз.База);
	//			//		Продолжить;
	//			//	Иначе
	//			//		ТекАвтор = СтрокиСоответствия[0].Соответствие;
	//			//	КонецЕсли;	
	//			//КонецЕсли;
	//			ТекКому = Справочники.Пользователи.НайтиПоНаименованию(ВыборкаВДБ.Кому, Истина);
	//			//Если Не ЗначениеЗаполнено(ТекКому) Тогда
	//			//	СтрокиСоответствия = ТаблицаПоБазам.НайтиСтроки(Новый Структура("База, Значение77, ТипОбъекта", СтрокаБаз.База, ВыборкаВДБ.Кому, "Справочник.Пользователи"));
	//			//	Если СтрокиСоответствия.Количество() = 0 Тогда
	//			//		Сообщить("Не указано соответствие пользователя " + ВыборкаВДБ.Кому + " с базой " + СтрокаБаз.База);
	//			//		Продолжить;
	//			//	Иначе
	//			//		ТекКому = СтрокиСоответствия[0].Соответствие;
	//			//	КонецЕсли;	
	//			//КонецЕсли;
	//			НоваяЗапись = РегистрыСведений.Ч_СообщенияЧата.СоздатьМенеджерЗаписи();
	//			ЗаполнитьЗначенияСвойств(НоваяЗапись, ВыборкаВДБ);
	//			НоваяЗапись.Автор = ТекАвтор;
	//			НоваяЗапись.Кому = ТекКому;
	//			ТекБаза = Справочники.ИнформационныеБазы.НайтиПоНаименованию(ВыборкаВДБ.БазаОбращения, Истина);
	//			Если ЗначениеЗаполнено(ТекБаза) Тогда
	//				НоваяЗапись.БазаОбращения = ТекБаза;
	//				//ИначеЕсли Не СтрокаВыборки.АвторАдмин Тогда	
	//				//	СтрокаВыборки.БазаОбращения = СтрокаБаз.База;
	//			Иначе
	//				НоваяЗапись.БазаОбращения = Справочники.ИнформационныеБазы.ПустаяСсылка();
	//			КонецЕсли;
	//			НоваяЗапись.Записать();
	//		КонецЦикла;	
	//	Исключение
	//	КонецПопытки;
	//КонецЕсли;	
	//}
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 700 
	|	РегистрСведенийЧ_СообщенияЧата.ИдентификаторСообщения,
	|	РегистрСведенийЧ_СообщенияЧата.Автор,
	|	РегистрСведенийЧ_СообщенияЧата.Кому,
	|	РегистрСведенийЧ_СообщенияЧата.ДатаВремя,
	|	РегистрСведенийЧ_СообщенияЧата.НомерСообщения,
	|	РегистрСведенийЧ_СообщенияЧата.Оформление,
	|	РегистрСведенийЧ_СообщенияЧата.Текст,
	|	ЕСТЬNULL(сабЧат_ОповещенияЧата.Прочитано, ИСТИНА) КАК Прочитано,
	|	ЕСТЬNULL(сабЧат_ОповещенияЧата.Показано, ИСТИНА) КАК Показано,
	|	РегистрСведенийЧ_СообщенияЧата.СообщениеТехподдержки,
	|	РегистрСведенийЧ_СообщенияЧата.АвторАдмин,
	|	РегистрСведенийЧ_СообщенияЧата.ИДИнцидента,
	|	РегистрСведенийЧ_СообщенияЧата.ОписаниеИнцидента,
	|	РегистрСведенийЧ_СообщенияЧата.ОбъектМетаданных,
	|	РегистрСведенийЧ_СообщенияЧата.Ответственный,
	|	РегистрСведенийЧ_СообщенияЧата.ИнцидентЗакрыт,
	|	РегистрСведенийЧ_СообщенияЧата.Файл,
	|	РегистрСведенийЧ_СообщенияЧата.БазаОбращения,
	|	РегистрСведенийЧ_СообщенияЧата.НеобходимОбмен,
	|	РегистрСведенийЧ_СообщенияЧата.Документ
	|ИЗ
	|	РегистрСведений.Ч_СообщенияЧата КАК РегистрСведенийЧ_СообщенияЧата
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сабЧат_ОповещенияЧата КАК сабЧат_ОповещенияЧата
	|		ПО РегистрСведенийЧ_СообщенияЧата.ИдентификаторСообщения = сабЧат_ОповещенияЧата.ИдентификаторСообщения
	|			И (сабЧат_ОповещенияЧата.Кому = &Автор)
	|ГДЕ
	|	(РегистрСведенийЧ_СообщенияЧата.Автор В (&Автор)
	|			ИЛИ РегистрСведенийЧ_СообщенияЧата.Кому В (&Автор)
	|			ИЛИ сабЧат_ОповещенияЧата.Кому В (&Автор)
	|			ИЛИ &Администратор = ИСТИНА
	|				И РегистрСведенийЧ_СообщенияЧата.СообщениеТехподдержки)
	|	И (РегистрСведенийЧ_СообщенияЧата.ДатаВремя >= &ДатаВремя1
	|				И РегистрСведенийЧ_СообщенияЧата.ДатаВремя <= &ДатаВремя2
	|			ИЛИ РегистрСведенийЧ_СообщенияЧата.Прочитано = ЛОЖЬ)
	|	И ВЫБОР
	|			КОГДА &ТекПользовательПишетВТП = ИСТИНА
	|				ТОГДА РегистрСведенийЧ_СообщенияЧата.СообщениеТехподдержки
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	РегистрСведенийЧ_СообщенияЧата.ДатаВремя УБЫВ";
	
	Запрос.УстановитьПараметр("Автор", ТекущийПользовательСеанса);
	Запрос.УстановитьПараметр("ТекПользовательПишетВТП", ТекПользовательПишетВТП);
	Запрос.УстановитьПараметр("Администратор", ЭтоАдмин);
	Запрос.УстановитьПараметр("ДатаВремя1", ДатаВремя1);
	Запрос.УстановитьПараметр("ДатаВремя2", ДатаВремя2);
	//Запрос.УстановитьПараметр("ПредметОбсуждения", ?(ЗначениеЗаполнено(ПредметОбсуждения), ПредметОбсуждения, Неопределено));
	
	Если НомерСтраницы = "История" Тогда 	                //для первого запроса ВСЕЙ истории чата
		Текст = СтрЗаменить(Запрос.Текст,"ПЕРВЫЕ 700","");
		Текст =	СтрЗаменить(Текст,"УБЫВ","");
		Запрос.Текст = Текст;
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выгрузить();
	Выборка.Сортировать("ДатаВремя");
	
	НовостиHTML = "<HTML><HEAD>
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type><LINK rel=stylesheet type=text/css href=""__STYLE__""><BASE href=""v8config://26d610bd-8712-4000-956d-0edbe58646d8/mdobject/idcf715f2f-493b-44cc-8c21-3424f7d402ea/8eb4fad1-1fa6-403e-970f-2c12dbb43e23"">
	|<META name=GENERATOR content=""MSHTML 11.00.9600.17041""></HEAD>
	|<BODY><font face=""Tahoma, Geneva, sans-serif"">";
	
	
	Если ПервыйЗапуск Тогда
		Страницы = "<p align = ""center""><font size=""1""> История сообщений: ";
		
		Страницы = Страницы + "<a href = ""v8tppage:" + "Вчера" + """>Вчера</a>";
		Страницы = Страницы + "  <a href = ""v8tppage:" + "7 дней" + """>7 дней</a>";
		Страницы = Страницы + "  <a href = ""v8tppage:" + "30 дней" + """>30 дней</a>";
		Страницы = Страницы + "  <a href = ""v8tppage:" + "История" + """>История</a>";
		//Если Выборка.Количество() Тогда
		//	НачальнаяДата = Выборка[0].ДатаВремя;
		//	Если НачальнаяДата < НачалоДня(ТекущаяДата()) Тогда
		//		Если НомерСтраницы = "Вчера" Тогда
		//			Страницы = Страницы + "Вчера";
		//		Иначе			
		//			Страницы = Страницы + "<a href = ""v8tppage:" + "Вчера" + """>Вчера</a>";		
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//	Если НачальнаяДата + 24*60*60 < НачалоДня(ТекущаяДата()) Тогда
		//		Если НомерСтраницы = "7 дней" Тогда
		//			Страницы = Страницы + " 7 дней";
		//		Иначе			
		//			Страницы = Страницы + "  <a href = ""v8tppage:" + "7 дней" + """>7 дней</a>";		
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//	Если НачальнаяДата + 7*24*60*60 < НачалоДня(ТекущаяДата()) Тогда
		//		Если НомерСтраницы = "30 дней" Тогда
		//			Страницы = Страницы + " 30 дней";
		//		Иначе			
		//			Страницы = Страницы + "  <a href = ""v8tppage:" + "30 дней" + """>30 дней</a>";		
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//	Если НачальнаяДата + 30*24*60*60 < НачалоДня(ТекущаяДата()) Тогда
		//		Если НомерСтраницы = "История" Тогда
		//			Страницы = Страницы + " История";
		//		Иначе			
		//			//Страницы = Страницы + "  <a href = ""v8tppage:" + "Все" + """>Все</a>";		
		//			Страницы = Страницы + "  <a href = ""v8tppage:" + "История" + """>История</a>";
		//		КонецЕсли;
		//	КонецЕсли;
		//	
		//КонецЕсли;
		Страницы = Страницы + "</font></p>";
		СтрокаИстории = Страницы;
	Иначе
		Страницы = СтрокаИстории;
	КонецЕсли;
	
	НовостиHTML = НовостиHTML + Страницы;
	НовостиHTML = НовостиHTML + "<script type=""text/javascript"">function message() {window.scroll(0,100000);}</script>";
	//НовостиHTML = НовостиHTML + "<script type=""text/javascript"">function message() {location = ""http://view.officeapps.live.com/op/view.aspx?src=http://ishopnew.qiwi.ru/files/qiwi_instructions.doc"";}</script>";
	//НовостиHTML = НовостиHTML + "<script type=""text/javascript"">function message() {location = ""https://docs.google.com/viewer?url=http://ishopnew.qiwi.ru/files/qiwi_instructions.doc"";}</script>";
	//НовостиHTML = НовостиHTML + "<script type=""text/javascript"">function message() {location = ""https://docs.google.com/spreadsheets/d/1mEbRDTcsVRtjR4KQm4seZwT3ewOJETNMnlFDTsLH54o/pubhtml"";}</script>";
	НовостиHTML_начало = НовостиHTML +  "
	|<table style=""width: 100%""><tbody>";
	
	
	//всегда добавляем администратора в список пользователей
	ПользовательАдмин = Справочники.сабЧат_ГруппыЧата.Техподдержка;
	Если НЕ СписокПользователей = Неопределено Тогда
		ТекЗначениеСписка = СписокПользователей.НайтиПоЗначению(ПользовательАдмин); 
		Если ТекЗначениеСписка = Неопределено Тогда
			//Если НЕ ЗначениеЗаполнено(ПредметОбсуждения) Тогда
				СписокПользователей.Вставить(0, ПользовательАдмин);
			//КонецЕсли;
			СписокНепрочтенных.Вставить(0, 0);
			СписокЗначениеИнциденты.Вставить(0, Истина);
			СписокМоихИнцидентов.Вставить(0, Ложь);
			СписокИБ.Вставить(0, сабОбщегоНазначения.ПолучитьТекущуюИБ());
			СписокОбращенияВТП.Вставить(0, Истина);
		КонецЕсли;
	КонецЕсли;
	
	НовостьВывода = 0;
	НовостиHTML_текст = "";
	ТекИБконст = сабОбщегоНазначения.ПолучитьТекущуюИБ();
	Для каждого ТекНовость Из Выборка Цикл
		НовостиHTML = "";

		Если НомерСтраницы = "" Тогда
			Если ТекНовость.ДатаВремя < НачалоДня(ТекущаяДата()) И НЕ ЗначениеЗаполнено(ПредметОбсуждения) Тогда
				Продолжить;		
			КонецЕсли;
		ИначеЕсли НомерСтраницы = "Вчера" Тогда
			Если ТекНовость.ДатаВремя + 24*60*60 < НачалоДня(ТекущаяДата()) И НЕ ЗначениеЗаполнено(ПредметОбсуждения) Тогда
				Продолжить;		
			КонецЕсли;
		ИначеЕсли НомерСтраницы = "7 дней" Тогда
			Если ТекНовость.ДатаВремя + 7*24*60*60 < НачалоДня(ТекущаяДата()) И НЕ ЗначениеЗаполнено(ПредметОбсуждения) Тогда
				Продолжить;		
			КонецЕсли;
		ИначеЕсли НомерСтраницы = "30 дней" Тогда
			Если ТекНовость.ДатаВремя + 30*24*60*60 < НачалоДня(ТекущаяДата()) И НЕ ЗначениеЗаполнено(ПредметОбсуждения) Тогда
				Продолжить;		
			КонецЕсли;
		КонецЕсли;
		
		//Коменты = ТекНовость.Комментарии;
		//КоличествоКоментов = Коменты.Количество(); 
		
		
		Содержание = "";
		Для Счетчик = 1 По СтрЧислоСтрок(ТекНовость.Текст) Цикл
			ТекСтрока = СтрПолучитьСтроку(ТекНовость.Текст, Счетчик);
			Содержание = Содержание + ТекСтрока + "<br>";
		КонецЦикла;
		
		СсылкаАвтор = ПолучитьНавигационнуюСсылку(ТекНовость.Автор);
		СсылкаФайл = "";
		Если ЗначениеЗаполнено(ТекНовость.Файл) Тогда
			СсылкаФайл = ПолучитьНавигационнуюСсылку(ТекНовость.Файл);
		КонецЕсли;	
		//СсылкаНовость = ПолучитьНавигационнуюСсылку(ТекНовость.Ссылка);
		//Ссылка = "b629561f02a877154ebda9dc932b9a0b";
		
		Если (ТекНовость.Автор = Текпользователь ИЛИ ТекНовость.Кому = Текпользователь ИЛИ (ТекНовость.СообщениеТехподдержки И Текпользователь = ПользовательАдмин)) И ЗначениеЗаполнено(ТекНовость.БазаОбращения) И ТекИБ = ТекИБконст Тогда
				
			НовостиHTML = НовостиHTML  + "<tr><td style=""width: 15%"" align=right><font size=""1""><A href=v8doc:" + СсылкаАвтор + ">" + ТекНовость.Автор + "</A></font></td>";
				
			Если ТекНовость.Показано Тогда
				НовостиHTML = НовостиHTML  + "<td><p style=""margin-left: 10px; font-size: 8pt"">" + ?(ЗначениеЗаполнено(СсылкаФайл), "<A href=v8doc:" + СсылкаФайл + ">", "") + Содержание + "</font></p></td>";
			Иначе
				НовостиHTML = НовостиHTML  + "<td><p style=""margin-left: 10px; font-size: 8pt""><b>" + ?(ЗначениеЗаполнено(СсылкаФайл), "<A href=v8doc:" + СсылкаФайл + ">", "") + Содержание + "</b></p></td>";
			КонецЕсли;

			//НовостиHTML = НовостиHTML  + "<td><td style=""width: 5%"" align=right><font size=""1"">" + ТекНовость.БазаОбращения + "</font></td>";
			
			НовостиHTML = НовостиHTML  + "<td><font size=""1"">" + ?(НачалоДня(ТекущаяДата()) = НачалоДня(ТекНовость.ДатаВремя), Формат(ТекНовость.ДатаВремя, "ДФ=ЧЧ:мм"), Формат(ТекНовость.ДатаВремя, "ДФ='dd.MM.yyyy ЧЧ:мм'") ) + "</font></td>";
			НовостиHTML = НовостиHTML  + "<td><p align=""right""><font size=""1"">" + ?(ТекНовость.Прочитано, "v", "-") + "</font></p></td>";
			
			Если ЭтоАдмин Тогда				
				Если ЗначениеЗаполнено(ТекНовость.ИДИнцидента) Тогда
					Если ТекНовость.ИнцидентЗакрыт Тогда
						НовостиHTML = НовостиHTML  + "<td><p align=""right""><font size=""1"">" + ТекНовость.ОписаниеИнцидента + "</font></p></td>";
					Иначе	
						НовостиHTML = НовостиHTML  + "<td align=""right""><font size=""1"">" + ТекНовость.ОписаниеИнцидента + "</font></td><td align=""right""><font size=""1"">" + ТекНовость.Ответственный + "</font></td><td style=""width: 10%"" align=""right""><font size=""1""><A href=v8jobclose:" + ТекНовость.ИдентификаторСообщения + ">X</A></font></td>";
					КонецЕсли;
				ИначеЕсли НЕ ТекНовость.ИнцидентЗакрыт Тогда
					НовостиHTML = НовостиHTML  + "<td style=""width: 2%"" align=right><font size=""1""></font></td><td><p align=""right""><font size=""1""><A href=v8job:" + ТекНовость.ИдентификаторСообщения + ">O</A></font></td>";
				КонецЕсли;
			КонецЕсли;
			НовостиHTML = НовостиHTML  +  "</tr>";
			
		КонецЕсли;
		
		Если НЕ ТекНовость.Прочитано И (НЕ ТекНовость.Автор = ТекущийПользовательСеанса ИЛИ (ЭтоАдмин И ТекНовость.Кому = ПользовательАдмин)) Тогда
			ЗвуковойСигнал = ?(НЕ ТекНовость.Показано, 2, 1);
		КонецЕсли;
		
		//формируем 4 списка значений для заполнения пользователей и синхронизации без обмена контекста формы
		ТекАвтор = ?((ТипЗнч(ТекНовость.Кому) = Тип("СправочникСсылка.сабЧат_ГруппыЧата") И НЕ ТекНовость.СообщениеТехподдержки), ТекНовость.Кому, ?(ТекНовость.СообщениеТехподдержки И ТекНовость.АвторАдмин, ТекНовость.Кому, ТекНовость.Автор));
		//Если (ЭтоАдмин и НЕ ТекНовость.АвторАдмин) ИЛИ (НЕ ЭтоАдмин И НЕ ТекНовость.Автор = ТекущийПользовательСеанса) Тогда
			Если НЕ СписокПользователей = Неопределено И НЕ ТекАвтор = ТекущийПользовательСеанса Тогда
				ТекЗначениеСписка = СписокПользователей.НайтиПоЗначению(ТекАвтор); 
				Если ТекЗначениеСписка = Неопределено Или (ТекЗначениеСписка <> Неопределено И СписокИБ[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение <> ТекНовость.БазаОбращения И СписокОбращенияВТП[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение <> ТекНовость.СообщениеТехподдержки) Тогда
					СписокПользователей.Добавить(ТекАвтор);
					Если НЕ ТекНовость.Прочитано И НЕ (ТекНовость.АвторАдмин ИЛИ ТекНовость.Автор = ТекущийПользовательСеанса) Тогда
						СписокНепрочтенных.Добавить(1);
					Иначе
						СписокНепрочтенных.Добавить(0);
					КонецЕсли;
					
					СписокЗначениеИнциденты.Добавить(ЗначениеЗаполнено(ТекНовость.Ответственный) ИЛИ ТекНовость.ИнцидентЗакрыт ИЛИ ТекНовость.АвторАдмин);
					СписокМоихИнцидентов.Добавить(ТекНовость.Ответственный = ТекущийПользовательСеанса);
					СписокИБ.Добавить(ТекНовость.БазаОбращения);
					СписокОбращенияВТП.Добавить(ТекНовость.СообщениеТехподдержки);
				Иначе
					Если НЕ ТекНовость.Прочитано И НЕ (ТекНовость.АвторАдмин ИЛИ ТекНовость.Автор = ТекущийПользовательСеанса) Тогда
						СписокНепрочтенных[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение = СписокНепрочтенных[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение + 1;
					КонецЕсли;
					СписокЗначениеИнциденты[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение = ЗначениеЗаполнено(ТекНовость.Ответственный) ИЛИ ТекНовость.ИнцидентЗакрыт ИЛИ ТекНовость.АвторАдмин;
					СписокМоихИнцидентов[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение = (ТекНовость.Ответственный = ТекущийПользовательСеанса);
					СписокИБ[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение = ТекНовость.БазаОбращения;
					СписокОбращенияВТП[СписокПользователей.Индекс(ТекЗначениеСписка)].Значение = ТекНовость.СообщениеТехподдержки;
				КонецЕсли;	
			КонецЕсли;
		//КонецЕсли;
		
		НовостиHTML_текст = НовостиHTML_текст + НовостиHTML;    //доп переменная для оптимизации обхода запроса
		
	КонецЦикла;
	
	НовостиHTML = НовостиHTML_начало + НовостиHTML_текст;
	//заполняем количество в соответствии
	НовостиHTML = НовостиHTML + "</tbody></table>";
	НовостиHTML = НовостиHTML + "<a name = ""forScroll""></a>";
	НовостиHTML = НовостиHTML + "</font></BODY></HTML>";
	
	
КонецПроцедуры

Процедура ПрочитатьНовые(ТекПользователь, ТолькоПоказанные = Ложь, Техподдержка = Ложь) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Ч_СообщенияЧата.ИдентификаторСообщения,
	               |	Ч_СообщенияЧата.ДатаВремя,
	               |	Ч_СообщенияЧата.Автор,
	               |	Ч_СообщенияЧата.Кому
	               |ИЗ
	               |	РегистрСведений.Ч_СообщенияЧата КАК Ч_СообщенияЧата
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА &Автор = НЕОПРЕДЕЛЕНО
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ Ч_СообщенияЧата.Автор = &Автор
	               |		КОНЕЦ
	               |	И (Ч_СообщенияЧата.Кому = &Кому
	               |			ИЛИ &Администратор = ИСТИНА
	               |				И Ч_СообщенияЧата.СообщениеТехподдержки = ИСТИНА)
	               |	И Ч_СообщенияЧата.Прочитано = ЛОЖЬ
	               |	И ВЫБОР
	               |			КОГДА &ТолькоПоказанные = ИСТИНА
	               |				ТОГДА Ч_СообщенияЧата.Показано = ЛОЖЬ
	               |			ИНАЧЕ ИСТИНА
	               |		КОНЕЦ
	               |	И Ч_СообщенияЧата.СообщениеТехподдержки = &Техподдержка";
	
	Запрос.УстановитьПараметр("Автор", ТекПользователь);
	Запрос.УстановитьПараметр("Кому", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("Администратор", БюджетныйНаСервере.РольАдминаДоступнаСервер());
	Запрос.УстановитьПараметр("ТолькоПоказанные", ТолькоПоказанные);
	Запрос.УстановитьПараметр("Техподдержка", Техподдержка);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = РегистрыСведений.Ч_СообщенияЧата.СоздатьМенеджерЗаписи();
		НоваяЗапись.ИдентификаторСообщения = Выборка.ИдентификаторСообщения;
		НоваяЗапись.Автор = Выборка.Автор;
		НоваяЗапись.Кому = Выборка.Кому;
		НоваяЗапись.Прочитать();
		Если НоваяЗапись.Выбран() Тогда
			Если НЕ ТолькоПоказанные Тогда
				НоваяЗапись.Прочитано = Истина;
			КонецЕсли;
			НоваяЗапись.Показано = Истина;	
			НоваяЗапись.Записать();
		КонецЕсли;
	КонецЦикла;
	
	
	//д1. 04.05.16 читаем расширенные оповещения
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	сабЧат_ОповещенияЧата.ИдентификаторСообщения,
	               |	сабЧат_ОповещенияЧата.Кому
	               |ИЗ
	               |	РегистрСведений.сабЧат_ОповещенияЧата КАК сабЧат_ОповещенияЧата
	               |ГДЕ
	               |	сабЧат_ОповещенияЧата.Прочитано = ЛОЖЬ
	               |	И ВЫБОР
	               |			КОГДА &ТолькоПоказанные = ИСТИНА
	               |				ТОГДА сабЧат_ОповещенияЧата.Показано = ЛОЖЬ
	               |			ИНАЧЕ ИСТИНА
	               |		КОНЕЦ
	               |	И сабЧат_ОповещенияЧата.Кому = &Кому";
	
	//Запрос.УстановитьПараметр("Автор", ТекПользователь);
	Запрос.УстановитьПараметр("Кому", ПараметрыСеанса.ТекущийПользователь);
	//Запрос.УстановитьПараметр("Администратор", БюджетныйНаСервере.РольАдминаДоступнаСервер());
	Запрос.УстановитьПараметр("ТолькоПоказанные", ТолькоПоказанные);
	//Запрос.УстановитьПараметр("Техподдержка", Техподдержка);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = РегистрыСведений.сабЧат_ОповещенияЧата.СоздатьМенеджерЗаписи();
		НоваяЗапись.ИдентификаторСообщения = Выборка.ИдентификаторСообщения;
		//НоваяЗапись.Автор = Выборка.Автор;
		НоваяЗапись.Кому = Выборка.Кому;
		НоваяЗапись.Прочитать();
		Если НоваяЗапись.Выбран() Тогда
			Если НЕ ТолькоПоказанные Тогда
				НоваяЗапись.Прочитано = Истина;
			КонецЕсли;
			НоваяЗапись.Показано = Истина;	
			НоваяЗапись.Записать();
		КонецЕсли;
	КонецЦикла;
	//конец д1. 04.05.16	
	
	
КонецПроцедуры

Процедура СоздатьНовоеСообщениеЧата(Кому, Текст, СообщениеТехподдержки = Ложь, ЭтоАдмин = Ложь, ОтИмени = Неопределено, Файл = Неопределено, ТекИБ = Неопределено, ИдентификаторСообщения = Неопределено, ПредметОбсуждения = Неопределено) Экспорт
	НоваяЗапись = РегистрыСведений.Ч_СообщенияЧата.СоздатьМенеджерЗаписи();
	НоваяЗапись.ДатаВремя = ТекущаяДата();
	НоваяЗапись.Текст = Текст;
	НоваяЗапись.СообщениеТехподдержки = СообщениеТехподдержки;
	Автор = ?(НЕ ОтИмени = Неопределено, ОтИмени, ПараметрыСеанса.ТекущийПользователь);
	НоваяЗапись.Автор = Автор;
	НоваяЗапись.АвторАдмин = ЭтоАдмин;
	НоваяЗапись.БазаОбращения = сабОбщегоНазначения.ПолучитьТекущуюИБ();
	//Если Кому = Неопределено Тогда
	//	НоваяЗапись.Кому = Справочники.Пользователи.Администратор; //в случае обращения в ТП	
	//Иначе	
	НоваяЗапись.Кому = Кому;
	//КонецЕсли;
	Если ИдентификаторСообщения = Неопределено Тогда
		НоваяЗапись.ИдентификаторСообщения = Новый УникальныйИдентификатор;
	Иначе
		НоваяЗапись.ИдентификаторСообщения = ИдентификаторСообщения;
	КонецЕсли;	
	Если Не Файл = Неопределено Тогда
		НоваяЗапись.Файл = Файл;
	КонецЕсли;
	
	Если Не ТекИБ = Неопределено Тогда
		НоваяЗапись.БазаОбращения = ТекИБ;
	КонецЕсли;
	
	//Если Константы.БазаТехподдержки.Получить() Тогда
	//	НоваяЗапись.НеобходимОбмен = Истина;
	//КонецЕсли;
	
	НоваяЗапись.Документ = ПредметОбсуждения;
	
	Если СообщениеТехподдержки И Не ЗначениеЗаполнено(ПредметОбсуждения) Тогда //ставим ИД последнего инцидента, если есть
		
		Если НЕ Текст = "!Инцидент закрыт" Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	Ч_СообщенияЧата.ИДИнцидента,
			|	Ч_СообщенияЧата.ОписаниеИнцидента,
			|	Ч_СообщенияЧата.ОбъектМетаданных,
			|	Ч_СообщенияЧата.Ответственный
			|ИЗ
			|	РегистрСведений.Ч_СообщенияЧата КАК Ч_СообщенияЧата
			|ГДЕ
			|	(Ч_СообщенияЧата.Автор = &Автор
			|			ИЛИ Ч_СообщенияЧата.Кому = &Автор)
			|	И Ч_СообщенияЧата.СообщениеТехподдержки = ИСТИНА
			|
			|УПОРЯДОЧИТЬ ПО
			|	Ч_СообщенияЧата.ДатаВремя УБЫВ";
			
			Запрос.УстановитьПараметр("Автор", ?(ЭтоАдмин, Кому, Автор));
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);	
				
			КонецЦикла;
		Иначе
			НоваяЗапись.ИнцидентЗакрыт = Истина;	
			
		КонецЕсли;
	КонецЕсли;
	НоваяЗапись.Записать();
	
	//д1. 04.05.16 расширение статуса сообщений (оповещение всех в группе) 
	Если ТипЗнч(НоваяЗапись.Кому) = Тип("СправочникСсылка.сабЧат_ГруппыЧата") Тогда
		ТЗПользователи = НоваяЗапись.Кому.Пользователи.Выгрузить();
		ТЗПользователи.Свернуть("Пользователь");
		ТЗПользователи = ТЗПользователи.ВыгрузитьКолонку("Пользователь");
	Иначе
		ТЗПользователи = Новый Массив;
		ТЗПользователи.Добавить(НоваяЗапись.Кому);
	КонецЕсли;
	Для каждого ТекСтрока Из ТЗПользователи Цикл
		Если ТекСтрока = Автор Тогда //пропускаем себя же
			Продолжить;		
		КонецЕсли;
		НоваяЗаписьСтатуса = РегистрыСведений.сабЧат_ОповещенияЧата.СоздатьМенеджерЗаписи();
		НоваяЗаписьСтатуса.ИдентификаторСообщения = НоваяЗапись.ИдентификаторСообщения;
		НоваяЗаписьСтатуса.Кому = ТекСтрока;
		НоваяЗаписьСтатуса.Записать();
	КонецЦикла;
	//д1. 04.05.16 конец расширения оповещения всех в группе
КонецПроцедуры

Функция ПолучитьОбсуждениеПредмета(ПредметОбсуждения) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	сабЧат_ГруппыЧата.Ссылка
	|ИЗ
	|	Справочник.сабЧат_ГруппыЧата КАК сабЧат_ГруппыЧата
	|ГДЕ
	|	сабЧат_ГруппыЧата.Документ = &Документ";
	
	Запрос.УстановитьПараметр("Документ", ПредметОбсуждения);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;	
	КонецЦикла;
	
	Возврат Неопределено;
	
	
	
	
КонецФункции // ()
