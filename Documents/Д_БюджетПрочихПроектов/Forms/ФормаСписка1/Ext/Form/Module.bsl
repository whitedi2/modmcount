﻿                                                                      	
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("ДокументСсылка.Д_БюджетПрочихПроектов") И Элементы.ДопИнформация.Пометка Тогда
		//КоличествоМес = КоличМесяцев(Элементы.Список.ТекущаяСтрока);
		
		МассивКнопок = Новый Массив;
		
		
		
		МассивКнопок.Добавить("БюджетЗакупок");	
		МассивКнопок.Добавить("БюджетПродаж");	
		МассивКнопок.Добавить("БюджетЗатрат");
		МассивКнопок.Добавить("КорректировкиБюджета");		
		МассивКнопок.Добавить("БюджетИнвестиций");

		
		СписокБП.Параметры.УстановитьЗначениеПараметра("Заявка", Элементы.Список.ТекущаяСтрока);
		
		//МассивЗапущенныхБП = ПолучитьБП(Элементы.Список.ТекущаяСтрока);
		//Для каждого ТекБП Из МассивКнопок Цикл
		//				
		//	Если (ТекБП = "БюджетЗатрат" ИЛИ ТекБП = "БюджетИнвестиций") И КоличествоМес = 1 Тогда
		//		Элементы[ТекБП].Доступность = Ложь;	
		//		Продолжить;
		//	Иначе
		//		Элементы[ТекБП].Доступность = Истина;	
		//	КонецЕсли;
		//	Если ТекБП = "КорректировкиБюджета" И КоличествоМес > 1 Тогда
		//		Элементы[ТекБП].Доступность = Ложь;
		//		Продолжить;
		//	Иначе
		//		Элементы[ТекБП].Доступность = Истина;	
		//	КонецЕсли;		
		//	
		//	Если МассивЗапущенныхБП.Найти(ТекБП) = Неопределено Тогда
		//		Элементы[ТекБП].Доступность = Истина;
		//	Иначе
		//		Элементы[ТекБП].Доступность = Ложь;
		//	КонецЕсли;
		//	
		//КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТЧСервер(ТекДокумент)
	СписокБП.Параметры.УстановитьЗначениеПараметра("Заявка", ТекДокумент);
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличМесяцев(ТекДокумент)
	ДатаНачала = НачалоМесяца(ТекДокумент.Сценарий.ДатаНачала + 60 * 60 * 24);
	ДатаОкончания = КонецМесяца(ТекДокумент.Сценарий.ДатаКонца);
	ТекДата = ДатаНачала;
	КоличествоМесяцевДо = 0;
	Пока ТекДата <= ДатаОкончания Цикл
		КоличествоМесяцевДо = КоличествоМесяцевДо + 1;
		ТекДата = ДобавитьМесяц(ТекДата, 1);
	КонецЦикла;
	
	Возврат КоличествоМесяцевДо;
КонецФункции // ()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// di 24.07.13
	НастройкиИнтерфейсаСервер.ВосстановитьНастройкиСписка(ЭтаФорма);	
	СписокБП.Параметры.УстановитьЗначениеПараметра("Заявка", Элементы.Список.ТекущаяСтрока);
	
	МассЗаданий = Новый Массив;
	
	Если Константы.сабФоновоеПроведение.Получить() Тогда
		ТекЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Конец", Дата('00010101000000')) );
		
		Для каждого ТекЭл Из ТекЗадания Цикл
			МассЗаданий.Добавить(ТекЭл.Ключ);
		КонецЦикла;
		
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ФонЗадания", МассЗаданий);
	Список.Параметры.УстановитьЗначениеПараметра("Дата1", Дата('20140101000000'));
	Список.Параметры.УстановитьЗначениеПараметра("Предприятие", ПараметрыСеанса.ДоступныеПредприятия);
	
КонецПроцедуры


&НаСервере
Функция ПолучитьБП(ТекЗаявка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УтверждениеБюджета.ТипБюджета
	               |ИЗ
	               |	БизнесПроцесс.УтверждениеБюджета КАК УтверждениеБюджета
	               |ГДЕ
	               |	УтверждениеБюджета.Заявка = &Заявка
	               |	И УтверждениеБюджета.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Заявка", ТекЗаявка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МассивБП = Новый Массив;
	Пока Выборка.Следующий() Цикл
		Если Выборка.ТипБюджета.Пустая() Тогда
			Продолжить;
		КонецЕсли;	
		ТекИмя = Выборка.ТипБюджета.Метаданные().ЗначенияПеречисления[Перечисления.Д_ТипыБюджетов.Индекс(Выборка.ТипБюджета)].Имя;
		МассивБП.Добавить(ТекИмя);
		Если ТекИмя = "БюджетЗатратСтарый" Тогда
			МассивБП.Добавить("БюджетПроизводства");
			МассивБП.Добавить("БюджетЗатрат");
		КонецЕсли;
	КонецЦикла;
	Возврат МассивБП;
КонецФункции // ()

&НаКлиенте
Процедура СписокБПВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТабДок = Новый ТабличныйДокумент;
	
	Печать(ТабДок, Элементы.Список.ТекущаяСтрока, Элементы.СписокБП.ТекущаяСтрока);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.ОтображатьГруппировки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("Документ.Д_Бюджет.Форма.ФормаПечатиЗатрат");
	ФормаПечати.ТабДок = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды, ТипБюджета)
	Если ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетЗатрат Тогда
		Если ПараметрКоманды.БезБюджетаПроизводства Тогда
			ТабДок = БюджетныйНаСервере.ВернутьТабличныйДокументДляСогласователей(Элементы.СписокБП.ТекущаяСтрока)
		Иначе
			Документы.Д_Бюджет.РечатьСебестоимостьСерверНовый(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета)
		КонецЕсли
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетЗакупок Тогда 
		Документы.Д_Бюджет.РассчитатьСырье(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);	
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетИнвестиций Тогда 
		Документы.Д_Бюджет.РассчитатьИнвестиции(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетПродаж Тогда 
		Документы.Д_Бюджет.РасчитатьПродажи(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.КорректировкиБюджета Тогда 
		//Документы.Д_Бюджет.ПечатьКорректировки(ТабДок, ПараметрКоманды, ТекБП.ТипБюджета);
		Документы.Д_Бюджет.РечатьСебестоимостьСерверНовый(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);	
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.КорректировкиИнвестиций Тогда 
		Документы.Д_Бюджет.ПечатьКорректировкиИнвестиций(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетПроизводства Тогда 
		Документы.Д_Бюджет.РечатьОбъемПроизводства(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);	
	ИначеЕсли ТипБюджета.ТипБюджета = Перечисления.Д_ТипыБюджетов.БюджетЗатратСтарый Тогда 
		Документы.Д_Бюджет.РечатьСебестоимостьСервер(ТабДок, ПараметрКоманды, ТипБюджета.ТипБюджета);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаАктивизации(АктивныйОбъект, Источник)
	а = 1;
КонецПроцедуры

&НаКлиенте
Процедура УтверждениеБюджета(Команда)
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("ДокументСсылка.Д_Бюджет") Тогда
		
		БезБюджетаПроизводства = БюджетныйНаСервере.ВернутьРеквизит(Элементы.Список.ТекущаяСтрока, "БезБюджетаПроизводства");
		
		МассивКнопок = Новый СписокЗначений;
		Если Не БезБюджетаПроизводства Тогда
			МассивКнопок.Добавить("БюджетПроизводства","Утверждение объема производства",,БиблиотекаКартинок.БизнесПроцесс);
			МассивКнопок.Добавить("БюджетЗакупок","Утверждение бюджета закупок",,БиблиотекаКартинок.БизнесПроцесс);
		КонецЕсли;	
		МассивКнопок.Добавить("БюджетПродаж","Утверждение бюджета продаж",,БиблиотекаКартинок.БизнесПроцесс);	
		МассивКнопок.Добавить("БюджетЗатрат","Утверждение затрат на переработку",,БиблиотекаКартинок.БизнесПроцесс);
		МассивКнопок.Добавить("КорректировкиБюджета","Утверждение корректировок затрат",,БиблиотекаКартинок.БизнесПроцесс);		
		МассивКнопок.Добавить("БюджетИнвестиций","Утверждение бюджета инвестиций",,БиблиотекаКартинок.БизнесПроцесс);
		МассивКнопок.Добавить("КорректировкиИнвестиций", "Утверждение корректировок инвестиций",,БиблиотекаКартинок.БизнесПроцесс); 
		
		КоличествоМес = КоличМесяцев(Элементы.Список.ТекущаяСтрока);
		
		МассивЗапущенныхБП = ПолучитьБП(Элементы.Список.ТекущаяСтрока);
		
		Для каждого ТекБП Из МассивКнопок Цикл
			
			Если (ТекБП.Значение = "БюджетЗатрат" ИЛИ ТекБП.Значение = "БюджетИнвестиций") И КоличествоМес = 1 Тогда
				ТекБП.Пометка = Истина;
				ТекБП.Представление = ТекБП.Представление + " (запущен)";
				Продолжить;
			//Иначе
			//	СписокМеню.Добавить(ТекБП);	
			КонецЕсли;
			Если (ТекБП.Значение = "КорректировкиБюджета" ИЛИ ТекБП.Значение = "КорректировкиИнвестиций") И КоличествоМес > 1 Тогда
					ТекБП.Пометка = Истина;
				ТекБП.Представление = ТекБП.Представление + " (запущен)";
				Продолжить;
			//Иначе
			//	Если СписокМеню.НайтиПоЗначению(ТекБП) = Неопределено Тогда
			//		СписокМеню.Добавить(ТекБП);	
			//	КонецЕсли;
			КонецЕсли;		
						
			Если МассивЗапущенныхБП.Найти(ТекБП.Значение) = Неопределено Тогда
			//	Если СписокМеню.НайтиПоЗначению(ТекБП) = Неопределено Тогда
			//		СписокМеню.Добавить(ТекБП);	
			//	КонецЕсли;
			Иначе
				ТекБП.Пометка = Истина;
				ТекБП.Представление = ТекБП.Представление + " (запущен)";
			КонецЕсли;
			
		КонецЦикла;
		НовСписок = Новый СписокЗначений;
		Для каждого ТекСтр Из МассивКнопок Цикл
			Если НЕ ТекСтр.Пометка Тогда
				НовСписок.Добавить(ТекСтр.Значение, ТекСтр.Представление, ТекСтр.Пометка, ТекСтр.Картинка);
			КонецЕсли;
		КонецЦикла;
		//Список1 = Новый СписокЗначений;
		//Список1.Добавить("Доставка",,Истина);
		//Список1.Добавить("Разгрузка",,Ложь);
		//Список1.Добавить("Картинка",,,БиблиотекаКартинок.Константа);
		//Вид = ВыбратьИзМеню(Список1, ЭтаФорма);
		Если НЕ НовСписок.Количество() Тогда
			Предупреждение("Все бизнес-процессы утверждения бюджетов запущены.");
			Возврат;
		КонецЕсли;
		
		ТекЭлемент = ВыбратьИзМеню(НовСписок, Элементы.Список);
		Если Не ТекЭлемент = Неопределено Тогда
			ОбработкаКоманды1(Элементы.Список.ТекущаяСтрока, Неопределено, ТекЭлемент.Значение);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДопИнформация(Команда)
	
	Элементы.ДопИнформация.Пометка = 1 - Элементы.ДопИнформация.Пометка;
	Элементы.Группа2.Видимость = Элементы.ДопИнформация.Пометка;
КонецПроцедуры


////////////////////////команда утвердить ////////////////////////////

&НаСервере
Функция ПоискБП1(Ссылка, ТипБюджета)
	//ищем созданные бизнес-процессы
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УтверждениеБюджета.Ссылка
	               |ИЗ
	               |	БизнесПроцесс.УтверждениеБюджета КАК УтверждениеБюджета
	               |ГДЕ
	               |	УтверждениеБюджета.Заявка = &Заявка
	               |	И УтверждениеБюджета.ТипБюджета = &ТипБюджета
	               |	И УтверждениеБюджета.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Заявка", Ссылка);
	Запрос.УстановитьПараметр("ТипБюджета", Перечисления.Д_ТипыБюджетов[ТипБюджета]);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;	
	КонецЕсли;
КонецФункции // ()

&НаКлиенте
Процедура ОбработкаКоманды1(ПараметрКоманды, ПараметрыВыполненияКоманды, ТипБюджета)
	
	//Если НЕ ПолучитьКоличествоСтрокТЧ1(ПараметрКоманды) Тогда
	//	Предупреждение("Не определен маршрут для утверждения юджета затрат.");
	//	Возврат;			
	//КонецЕсли;
	
	БП = ПоискБП1(ПараметрКоманды, ТипБюджета);
	Если НЕ БП = Неопределено Тогда
		Предупреждение("Документ уже имеет запущенный бизнес-процесс указанного типа.");
		Возврат;		
	КонецЕсли;
	
	Если Вопрос("После старта процесса согласования, изменения утверждаемого бюджета, станут невозможны. Уверены что хотите стартовать бизнес процесс?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		
		ТекФормаБП = ПолучитьФорму("БизнесПроцесс.УтверждениеБюджета.Форма.ФормаНовый");
		ТекФормаБП.Объект.Автор = БюджетныйНаСервере.ПолучитьПользователя();
		ТекФормаБП.Объект.Описание = БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Комментарий");
		ТекФормаБП.Объект.Заявка = ПараметрКоманды;
		ТекФормаБП.Объект.ОснованиеЗаблокирован = Истина;
		
		
		ДанныеФормы = ТекФормаБП.Объект;
		СоздатьБПИнтерактивно1(ДанныеФормы, ПараметрКоманды, ТипБюджета);
		КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
		ТекФормаБП.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьБПИнтерактивно1(НовыйБП, ПараметрКоманды, ТипБюджета)
	
	НовыйБП.Автор = ПараметрыСеанса.ТекущийПользователь;
	НовыйБП.Описание = ПараметрКоманды.Комментарий;
	НовыйБП.Дата = ТекущаяДата();
	НовыйБП.Заявка = ПараметрКоманды;
	НовыйБП.Предприятие = ПараметрКоманды.Предприятие;
	НовыйБП.ТипБюджета = Перечисления.Д_ТипыБюджетов[ТипБюджета];
	
	
КонецФункции

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройкиСписка();

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиСписка()

	НастройкиИнтерфейсаСервер.СохранитьНастройкиСписка(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	МассЗаданий = Новый Массив;
	ОбновитьСерв(МассЗаданий);
	Список.Параметры.УстановитьЗначениеПараметра("ФонЗадания", МассЗаданий);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСерв(МассЗаданий)
	
	Если Константы.сабФоновоеПроведение.Получить() Тогда		
		ТекЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Конец", Дата('00010101000000')) );
		
		Для каждого ТекЭл Из ТекЗадания Цикл
			МассЗаданий.Добавить(ТекЭл.Ключ);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	//Если НЕ Копирование Тогда
	//	Отказ = Истина;	
	//КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ОтражениеПроводимыхДокументов()
	МассЗаданий = ПолучитьМассивЗаданий();
	
	Если МассЗаданий.Количество() Тогда
		Элементы.ПроводимыеДокументы.Видимость = Истина;
		//добавляем новые
		Для каждого ТекДокумент Из МассЗаданий Цикл
			Если НЕ ПроводимыеДокументы.НайтиСтроки(Новый Структура("Документ", ТекДокумент.Документ)).Количество() Тогда
				НоваяСтрока = ПроводимыеДокументы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекДокумент);		
			КонецЕсли;		
		КонецЦикла;
		
		//удаляем проведенные
		МассивКУдалению = Новый Массив;
		Для каждого ТекСтрока Из ПроводимыеДокументы Цикл
			Отсутствует = Истина;
			Для каждого ТекДокумент Из МассЗаданий Цикл
				Если ТекДокумент.Документ = ТекСтрока.Документ Тогда
					Отсутствует = Ложь;				
				КонецЕсли;			
			КонецЦикла; 
			Если Отсутствует Тогда
				МассивКУдалению.Добавить(ТекСтрока);		
			КонецЕсли;		
		КонецЦикла; 
		Для каждого ТекЭлементМассива Из МассивКУдалению Цикл
			ПроводимыеДокументы.Удалить(ТекЭлементМассива);		
		КонецЦикла;
	Иначе
		ПроводимыеДокументы.Очистить();
		Элементы.ПроводимыеДокументы.Видимость = Ложь;
		
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивЗаданий()
	
	МассЗаданий = Новый Массив;
	
	Если Константы.сабФоновоеПроведение.Получить() Тогда
		ТекЗадания = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Конец", Дата('00010101000000')) );
		
		Для каждого ТекЭл Из ТекЗадания Цикл
			МассЗаданий.Добавить(ТекЭл.Ключ);
		КонецЦикла;
		
	Иначе
		Возврат МассЗаданий;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Д_Бюджет.Ссылка КАК Документ,
	               |	Д_Бюджет.Сценарий,
	               |	Д_Бюджет.Предприятие,
	               |	""Проведение..."" КАК Проведение
	               |ИЗ
	               |	Документ.Д_Бюджет КАК Д_Бюджет
	               |ГДЕ
	               |	Д_Бюджет.Номер В(&Номер)";
	
	Запрос.УстановитьПараметр("Номер", МассЗаданий);
	
	Результат = Запрос.Выполнить();
		
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Результат.Выгрузить());
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если БПСервер.ПолучитьКонстантуНаСервере("сабФоновоеПроведение") Тогда
		ПодключитьОбработчикОжидания("ОтражениеПроводимыхДокументов", 1);
	КонецЕсли;
	
КонецПроцедуры





