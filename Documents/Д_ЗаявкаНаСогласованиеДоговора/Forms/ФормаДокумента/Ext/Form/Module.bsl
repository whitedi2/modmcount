﻿///////////////////////////////////общие процедуры и функции
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//если уже есть БП по документу, то не отражаем кнопки запуска БП
	
	ВозможностьРедактированияИзАвтомаршрута = Ложь;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекБП = БПСервер.НайтиТекущийБПСервер(Объект.Ссылка);
		Если НЕ ТекБП = Неопределено Тогда
			ТекБПСтруРекв = БюджетныйНаСервере.ВернутьРеквизиты(ТекБП, "ОснованиеЗаблокирован, Стартован, ОтправлятьВсем");
			ВозможностьРедактированияИзАвтомаршрута = БПСервер.ТекПользовательИсполнительДокумента(Объект.Ссылка, Истина);
		КонецЕсли;
	Иначе
		ТекБП = Неопределено;
		ТекБПСтруРекв = Новый Структура;
		ВсемСразу = Неопределено;
	КонецЕсли;
	
	Если НЕ ТекБП = Неопределено Тогда
		ТекДоступность = ТекБПСтруРекв.ОснованиеЗаблокирован;
		Если ТекДоступность = Неопределено Тогда
			ТекДоступность = ТекБПСтруРекв.Стартован;
		КонецЕсли;
		БюджетныйНаКлиенте.ФормаТолькоПросмотр(Объект, ЭтаФорма, ТекДоступность И НЕ ВозможностьРедактированияИзАвтомаршрута);
		Элементы.ФормаДокументСогласовать.Заголовок = "Отправить и закрыть";
		Если ЗначениеЗаполнено(ТекБП) Тогда
			Элементы.ДобавитьКому.Доступность = 1 - ТекДоступность;
			Элементы.ФормаДокументСогласовать.Доступность = 1 - ТекДоступность;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ВидимостьВсем.Подсказка = "Документ будет отражаться в списке у всех пользователей, которым доступно предприятие.";
	//Элементы.ВидимостьВсем.Заголовок = "Доступен пользователям предприятиия: " + Строка(Объект.Предприятие);
	ПредприятиеПриИзменении(Неопределено);

	//Если Не РежимВосстановления Тогда
	//	ЭтаФорма.ПодключитьОбработчикОжидания("АвтосохранениеРеквизитовФормыНаКлиенте", 30);
	//КонецЕсли;	
	
	//формируем красивые списки
	ДоступныеПредприятия = БюджетныйНаСервере.ПолучитьПредприятия();
	Если ДоступныеПредприятия.Количество() < 15 Тогда
		БюджетныйНаКлиенте.ЗаполнитьСписокРеквизитаДубль2(ЭтаФорма, "СписокВыбора_Предприятие", ДоступныеПредприятия, Объект.Предприятие);
	КонецЕсли;
	
	УстановитьВидимость();
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Если ПустаяСтрока(Объект.Кому) Тогда
			Объект.Кому = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
		Объект.Дата = ТекущаяДата();
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Элементы.ОтслеживатьЗаявку.Пометка = БПСервер.ПроверитьОтслеживаниеЗаявки(Объект.Ссылка, ПараметрыСеанса.ТекущийПользователь);
	КонецЕсли;
	
	сабОбщегоНазначения.ОбновитьКоличествоПрикрепленныхФайловСервер(ЭтаФорма);
	Если Параметры.Свойство("РежимВосстановления") и Параметры.РежимВосстановления Тогда
		сабОбщегоНазначения.ВосстановлениеРеквизитовФормы(ЭтаФорма);
		РежимВосстановления = Истина;
	Иначе 
		РежимВосстановления = Ложь;
	КонецЕсли;
		
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма, Ложь);
	
	Период.ДатаНачала = Объект.ДатаДоговора;
	Период.ДатаОкончания = Объект.ДатаОкончания;
	
	Если Параметры.Свойство("ВидСЗ") Тогда
		Объект.ВидСЗ = Параметры.ВидСЗ;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьПодчиненныйДоговор();	
	Иначе
		Элементы.ДоговорПодчиненный.Видимость = Ложь;
		Элементы.ПрикрепленныеОригиналы.Видимость = Ложь;	
	КонецЕсли;
	
	ПроверитьСтатьиДДСДляОтбора();
	
	ВидДоговораПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатьиДДСДляОтбора()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатьиДвиженияДенежныхСредств.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиДвиженияДенежныхСредств
	|ГДЕ
	|	СтатьиДвиженияДенежныхСредств.ИспользуетсяВДоговорах = ИСТИНА";
	
	//Запрос.УстановитьПараметр("", );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ЕстьСтатьиДляДоговоров = Выборка.Количество() > 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Отказ = 1 - ПроверитьЗаполнение();
	сабОбщегоНазначения.ОчиститьАвтосохраненияОбъекта(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныйДоговор()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДоговорыКонтрагентов.Ссылка КАК Ссылка,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПрикрепленныеОбъекты.Объект) КАК Количество
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПрикрепленныеОбъекты КАК ПрикрепленныеОбъекты
	               |		ПО ДоговорыКонтрагентов.Ссылка = ПрикрепленныеОбъекты.Владелец
	               |			И (ПрикрепленныеОбъекты.ВидОбъекта = ЗНАЧЕНИЕ(Перечисление.ВидыПрикрепленныхОбъектов.Договор))
	               |ГДЕ
	               |	ДоговорыКонтрагентов.ДокументОснование = &ДокументОснование
	               |	И ДоговорыКонтрагентов.ПометкаУдаления = ЛОЖЬ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДоговорыКонтрагентов.Ссылка";
	
	Запрос.УстановитьПараметр("ДокументОснование", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДоговорПодчиненный = Выборка.Ссылка;
		Если Выборка.Количество Тогда
			ПрикрепленныеОригиналы = "Объекты (" + Строка(Выборка.Количество) + ")";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКому(Команда)
	Если НЕ Объект.Рецензенты.Количество() И НЕ ПустаяСтрока(Объект.Кому) И ТипЗнч(Объект.Кому) = Тип("СправочникСсылка.Пользователи") Тогда
		НоваяСтрока = Объект.Рецензенты.Добавить();
		НоваяСтрока.Пользователь = Объект.Кому;
	КонецЕсли;
	
	ТекПользователь = ОткрытьФормуМодально("Справочник.Пользователи.ФормаВыбора");
	Если НЕ ТекПользователь = Неопределено Тогда
		
		НетВБазе = БюджетныйНаСервере.ВернутьРеквизит(ТекПользователь, "НеУчаствуетВДокументообороте");
		Если НетВБазе Тогда
			Если Вопрос("Пользователь " + Строка(ТекПользователь) + " не участвует в документообороте, т.к. не имеет доступа к базе. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
				Возврат;	
			КонецЕсли;	
		КонецЕсли;	
		
		НоваяСтрока = Объект.Рецензенты.Добавить();
		НоваяСтрока.Пользователь = ТекПользователь;
	Иначе
		Возврат;
	КонецЕсли;
	СформироватьКому(ТекПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура КомуПриИзменении(Элемент)
	//Проверяем пользователей по наименованию. разделитель ;
	Если ТипЗнч(Объект.Кому) = Тип("Строка") И НЕ ПустаяСтрока(Объект.Кому) Тогда
		ТекСтрока = СтрЗаменить(Объект.Кому, "; ", ";");
		МассивИмен = Новый Массив;
		ТекИмя = "";
		Для ТекСимвол = 1 По СтрДлина(ТекСтрока) Цикл
			
			Если Сред(ТекСтрока, ТекСимвол, 1) = ";" Тогда
				МассивИмен.Добавить(ТекИмя);
				ТекИмя = "";
			Иначе
				ТекИмя = ТекИмя + Сред(ТекСтрока, ТекСимвол, 1);			
			КонецЕсли;	
			
		КонецЦикла;
		МассивИмен.Добавить(ТекИмя);
		Для каждого ТекИмя Из МассивИмен Цикл	
			Если НайтиИмя(ТекИмя) = Неопределено Тогда
				Предупреждение("Пользователь " + Строка(ТекИмя) + " не найден в справочнике.");
				СформироватьКому();
				Возврат;
			КонецЕсли;		
		КонецЦикла;
		СформироватьТЧ(МассивИмен);
	Иначе
		НетВБазе = БюджетныйНаСервере.ВернутьРеквизит(Объект.Кому, "НеУчаствуетВДокументообороте");
		Если НетВБазе Тогда
			Если Вопрос("Пользователь " + Строка(Объект.Кому) + " не участвует в документообороте, т.к. не имеет доступа к базе. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
				Объект.Кому = ПользовательПустаяСсылка();
				Возврат;	
			КонецЕсли;	
		КонецЕсли;	
		
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКому(ТекПользователь = Неопределено)
	
	//Если Объект.Рецензенты.Количество() > 1 Тогда
	//	СтрокаКому = "";
	//	Для каждого ТекРецензент Из Объект.Рецензенты Цикл
	//		СтрокаКому = СтрокаКому + Строка(ТекРецензент.Пользователь) + "; ";		
	//	КонецЦикла;
	//	СтрокаКому = Лев(СтрокаКому, СтрДлина(СтрокаКому) - 2);
	//	Объект.Кому = СтрокаКому;
	//Иначе
	//	Если НЕ ТекПользователь = Неопределено Тогда
	//		Объект.Кому = ТекПользователь;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если Элементы.ДобавитьКому.Видимость Тогда
		СтрокаКому = "";
		Для каждого ТекРецензент Из Объект.Рецензенты Цикл
			СтрокаКому = СтрокаКому + Строка(ТекРецензент.Пользователь) + "; ";		
		КонецЦикла;
		СтрокаКому = Лев(СтрокаКому, СтрДлина(СтрокаКому) - 2);
		Объект.Кому = СтрокаКому;
	Иначе
		Объект.Кому = ТекПользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТЧ(МассивИмен)
	Объект.Рецензенты.Очистить();
	Для каждого ТекПользователь Из МассивИмен Цикл
		НоваяСтрока = Объект.Рецензенты.Добавить();
		НоваяСтрока.Пользователь = НайтиИмя(ТекПользователь);	
	КонецЦикла; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиИмя(ТекИмя)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", ТекИмя);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции // ()

&НаКлиенте
Процедура КомуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.Кому = "" И Элементы.ДобавитьКому.Видимость = Ложь Тогда
		Объект.Кому = ПользовательПустаяСсылка();
	КонецЕсли;	
		
	Если ТипЗнч(Объект.Кому) = Тип("Строка") Тогда
		СтандартнаяОбработка = Ложь;
		МассивСтарыхРецензентов = Новый Массив;
		Для каждого ТекРецензент Из Объект.Рецензенты Цикл
			МассивСтарыхРецензентов.Добавить(ТекРецензент.Пользователь);		
		КонецЦикла; 
		
		МассивРецензентов = ОткрытьФормуМодально("Документ.Д_СлужебнаяЗаписка.Форма.ФормаРецензенты", Новый Структура("Рецензенты", МассивСтарыхРецензентов));
		Если НЕ МассивРецензентов = Неопределено Тогда
			Объект.Рецензенты.Очистить();
			Для каждого ТекРецензент Из МассивРецензентов Цикл
				НоваяСтрока = Объект.Рецензенты.Добавить();
				НоваяСтрока.Пользователь = ТекРецензент;			
			КонецЦикла;
			СформироватьКому();
		КонецЕсли;
	ИначеЕсли Объект.Кому = Неопределено Тогда
		Объект.Кому = ПользовательПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомуОчистка(Элемент, СтандартнаяОбработка)
	Объект.Рецензенты.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеПриИзменении(Элемент)
	Элементы.ВидимостьВсем.Подсказка = "Документ будет отражаться в списке у всех пользователей, которым доступно предприятие <" + Строка(Объект.Предприятие) + ">.";
	//Элементы.ВидимостьВсем.Заголовок = "Доступен пользователям предприятиия: " + Строка(Объект.Предприятие);
	
	СтруктураДанных = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Предприятие, "УчетПоПодразделениям, ВидДеятельности", Ложь);
	
	Если НЕ СтруктураДанных = Неопределено Тогда
		Элементы.Подразделение.Видимость = СтруктураДанных.УчетПоПодразделениям;
		Если НЕ Элемент = Неопределено Тогда 
			Объект.Подразделение = СтруктураДанных.ВидДеятельности
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредприятиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если СписокВыбора_Предприятие.Количество() Тогда
		ТекЗначение = ВыбратьИзСписка(СписокВыбора_Предприятие, Элемент, СписокВыбора_Предприятие.НайтиПоЗначению(Объект.Предприятие));	
		БюджетныйНаКлиенте.ПриНачалеВыбораРеквизитаВСпискеДубль2(ЭтаФорма, "СписокВыбора_Предприятие", ТекЗначение, "Предприятия", Объект.Предприятие, СтандартнаяОбработка, Ложь);
		ПредприятиеПриИзменении(Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытьФорму" Тогда
		//ЭтаФорма.Записать();
		ЭтаФорма.Закрыть();
	ИначеЕсли ИмяСобытия = "УстановитьДоступность" Тогда
		Объект.ТекущийБизнесПроцесс = Параметр.ТекущийБизнесПроцесс;
		Записать();
	ИначеЕсли ИмяСобытия = "Пересчитать" Тогда
		Закрыть();
	ИначеЕсли ИмяСобытия = "ПрикрепленныеФайлы" Тогда	
		сабОбщегоНазначенияКлиент.ОбновитьКоличествоПрикрепленныхФайлов(ЭтаФорма);
	ИначеЕсли ИмяСобытия = "РазрешитьРедактированиеФормы" Тогда	
		ПриОткрытии(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	сабОбщегоНазначенияКлиент.ПослеЗаписиАвтосохраняемойФормы(ЭтаФорма);
КонецПроцедуры

&НаСервереБезКонтекста
Функция  ПользовательПустаяСсылка()
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура АвтосохранениеРеквизитовФормыНаКлиенте()
	
	Если НЕ Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.Текстовка = Элементы.Текстовка.ТекстРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.УсловияОплаты = Элементы.УсловияОплаты.ТекстРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.НаименованиеДоговора = Элементы.НаименованиеДоговора.ТекстРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.Комментарий = Элементы.Комментарий.ТекстРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Объект.НомерДоговора = Элементы.НомерДоговора.ТекстРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	
	АвтосохранениеРеквизитовФормыНаСервере();		
	
КонецПроцедуры

&НаСервере 
Процедура АвтосохранениеРеквизитовФормыНаСервере()
	
	сабОбщегоНазначения.АвтосохранениеРеквизитовФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если СписокВыбора_Подразаделение.Количество() Тогда
		ТекЗначение = ВыбратьИзСписка(СписокВыбора_Подразаделение. Элемент, СписокВыбора_Подразаделение.НайтиПоЗначению(Объект.Подразделение));	
		БюджетныйНаКлиенте.ПриНачалеВыбораРеквизитаВСпискеДубль2(ЭтаФорма, "СписокВыбора_Подразаделение", ТекЗначение, "ВидыДеятельности", Объект.Подразделение, СтандартнаяОбработка, Ложь);
	КонецЕсли;

КонецПроцедуры

////////////////////конец общих процедур и функций

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
Функция ПолучитьДанныеКонтрагентПриИзменении(Контрагент)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("НаименованиеПолное", Контрагент.НаименованиеПолное);
	СтруктураДанные.Вставить("СчетКонтрагента", Контрагент.ОсновнойБанковскийСчет);
	СтруктураДанные.Вставить("ИННПолучателя", Контрагент.ИНН);
	СтруктураДанные.Вставить("КПППолучателя", Контрагент.КПП);
	СтруктураДанные.Вставить("НазначениеПлатежа", Контрагент.ОсновнойБанковскийСчет.ТекстНазначения);
	СтруктураДанные.Вставить("ТекстКорреспондента", Контрагент.ОсновнойБанковскийСчет.ТекстКорреспондента);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()


&НаКлиенте
Процедура ЗаявкаКонтрагентПриИзменении(Элемент)
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Элементы.Заявка.ТекущиеДанные.Контрагент);
	
	Элементы.Заявка.ТекущиеДанные.СчетКонтрагента = СтруктураДанные.СчетКонтрагента;
КонецПроцедуры

&НаКлиенте
Процедура АдресатыПользовательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	БюджетныйНаКлиенте.ДобавитьГруппуПользователей(Элементы, ВыбранноеЗначение, СтандартнаяОбработка);	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	ОткрытьФормумодально("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора, РасширенныйПодбор, ЗакрыватьПриВыборе", Истина, Истина, Ложь),Элементы.Адресаты); 
КонецПроцедуры

&НаКлиенте
Процедура ОтслеживатьЗаявку(Команда)
	
	Если Объект.Ссылка.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Перед тем как отслеживать заявку её нужно записать!";
		Сообщение.Сообщить();
	Иначе	
		ОтслеживатьСЗ = НЕ Элементы.ОтслеживатьЗаявку.Пометка;
		БПСервер.ОтслеживатьЗаявкуНаСервере(ОтслеживатьСЗ, Объект.Ссылка);
		Элементы.ОтслеживатьЗаявку.Пометка = ОтслеживатьСЗ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗамещенныеПриказыПриказНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Форма = ПолучитьФорму("Документ.Д_СлужебнаяЗаписка.ФормаВыбора", , Элемент);
	ЭлементОтбора = Форма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидСЗ");	
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ПравоеЗначение = ПредопределенноеЗначение("Справочник.Д_ВидыВнутреннихДокументов.Приказ");
	Форма.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлятьНаУтверждениеПриИзменении(Элемент)
	Если НаправлятьНаУтверждение = "Всем сразу" Тогда
		Объект.ОтправлятьВсем = Истина;
	Иначе
		Объект.ОтправлятьВсем = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвольнаяСЗПриИзменении(Элемент)
	
	Объект.ВидМероприятия = "";
	
	УстановитьВидимость();
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	
	ЭтоДопСоглашение = Объект.ВидСЗ = ПредопределенноеЗначение("Справочник.Д_ВидыВнутреннихДокументов.ЗаявкаНаСогласованиеДопСоглашения");
	Элементы.Договор.Видимость = ЭтоДопСоглашение;
	Элементы.УсловияОплаты.Видимость = НЕ ЭтоДопСоглашение;
	Элементы.Контрагент.Видимость = НЕ ЭтоДопСоглашение;
	Элементы.Контрагент1.Видимость = ЭтоДопСоглашение;
	Элементы.Текстовка.Заголовок = ?(ЭтоДопСоглашение, "Что изменилось", "Предмет договора");
	Элементы.Группа23.Заголовок = ?(ЭтоДопСоглашение, "Реквизиты доп. соглашения", "Реквизиты договора");
	Если ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаГруппа1.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании.ПодчиненныеЭлементы.Количество() Тогда
		ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаГруппа1.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании.ПодчиненныеЭлементы[0].Видимость = НЕ ЭтоДопСоглашение;
	КонецЕсли;
	Если ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаГруппа1.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании.ПодчиненныеЭлементы.Количество() > 1 Тогда
		ЭтаФорма.КоманднаяПанель.ПодчиненныеЭлементы.ФормаГруппа1.ПодчиненныеЭлементы.ФормаСоздатьНаОсновании.ПодчиненныеЭлементы[1].Видимость = ЭтоДопСоглашение;
	КонецЕсли;
	
	//Заголовок = Строка(Объект.ВидСЗ) + ?(ЗначениеЗаполнено(Объект.Ссылка), Строка(Объект.Номер) + " от " + Формат(Объект.Дата, "ДФ=dd.MM.yyyy"), "");
КонецПроцедуры	

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПериодПриИзмененииНаСервере();
	
	ПолучитьНаименованиеДоговора();
	
КонецПроцедуры

&НаСервере
Процедура ПериодПриИзмененииНаСервере()

	Объект.ДатаДоговора = Период.ДатаНачала;
	Объект.ДатаОкончания = Период.ДатаОкончания;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНаименованиеДоговора()
	
	Объект.НаименованиеДоговора = ?(Объект.ВидСЗ = ПредопределенноеЗначение("Справочник.Д_ВидыВнутреннихДокументов.СогласованиеДоговораТММ"), "ТММ/", "РБ/") + ?(ЗначениеЗаполнено(Объект.ВидМероприятия), Объект.ВидМероприятия + "/", "") + Формат(Объект.ДатаДоговора, "ДФ=dd.MM.yy") + "/" + Формат(Объект.ДатаОкончания, "ДФ=dd.MM.yy"); 
	
КонецПроцедуры	

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ ЗавершениеРаботы И Не РежимВосстановления Тогда
		сабОбщегоНазначения.ОчиститьАвтосохраненияОбъекта(Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДоговораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СписокЗн = Новый СписокЗначений;
	СписокЗн.Добавить("Договор аренды");
	СписокЗн.Добавить("Договор займа");
	СписокЗн.Добавить("Договор купли-продажи");
	СписокЗн.Добавить("Договор о полной материальной ответственности");
	СписокЗн.Добавить("Договор поставки");
	СписокЗн.Добавить("Договор услуг");
	СписокЗн.Добавить("Договор перевозки");
	СписокЗн.Добавить("Договор подряда");
	СписокЗн.Добавить("Договор финансовой аренды(лизинга)");
	СписокЗн.Добавить("Договор страхования");
	СписокЗн.Добавить("Договор хранения");
		
	ВыбранноеЗначение = ВыбратьИзМеню(СписокЗн, Элемент);
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		Объект.НаименованиеДоговора = ВыбранноеЗначение.Значение;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	СтруктураРекв = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Договор, "Подразделение, стр_ЦФО, Предприятие, Организация", Ложь);
	Объект.ЮрЛицоКомпании = СтруктураРекв.Организация;
	Объект.стрЦФО = СтруктураРекв.стр_ЦФО;
	Объект.Подразделение = СтруктураРекв.Подразделение;
	//ЗаполнитьЗначенияСвойств(Объект, СтруктураРекв);
	//ПредприятиеПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВидСЗПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепленныеОригиналыНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("РегистрСведений.ПрикрепленныеОбъекты.ФормаСписка", Новый Структура("Владелец", ДоговорПодчиненный)); 
КонецПроцедуры
	
&НаСервере
Процедура ВидДоговораПриИзмененииНаСервере()
	
	НовыйМассив = Новый Массив();
	
	Если НЕ сабОбщегоНазначенияПовтИсп.МассивДоговоровСПокупателем().Найти(Объект.ВидДоговора) = Неопределено Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Доход", Истина);
		НовыйМассив.Добавить(НовыйПараметр);
	ИначеЕсли НЕ сабОбщегоНазначенияПовтИсп.МассивДоговоровСПоставщиком().Найти(Объект.ВидДоговора) = Неопределено Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.Доход", Ложь);
		НовыйМассив.Добавить(НовыйПараметр);
	КонецЕсли;
	
	Если ЕстьСтатьиДляДоговоров Тогда
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ИспользуетсяВДоговорах", Истина);
		НовыйМассив.Добавить(НовыйПараметр);
	КонецЕсли;
	
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.СтатьяДДС.ПараметрыВыбора = НовыеПараметры;
	
КонецПроцедуры


&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	ВидДоговораПриИзмененииНаСервере();
КонецПроцедуры
	
